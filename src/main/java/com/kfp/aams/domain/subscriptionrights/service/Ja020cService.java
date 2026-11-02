package com.kfp.aams.domain.subscriptionrights.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020cDataDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020cDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020cFilterDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020cSaveDto;
import com.kfp.aams.domain.subscriptionrights.entity.Sjt0fs;
import com.kfp.aams.domain.subscriptionrights.entity.Sjt0fsId;
import com.kfp.aams.domain.subscriptionrights.mapper.Ja020cMapper;
import com.kfp.aams.domain.subscriptionrights.mapper.querydsl.Ja020cJpaRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja020cService {

    private final Ja020cMapper mapper;
    private final Ja020cJpaRepository jpaRepository;
    private final WorkDateService workDateService;

    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    public List<LocalDate> getDates(String corpGr, String trCd) {
        if (!nonblank(corpGr)) {
            return List.of();
        }
        return mapper.selectDates(corpGr.trim(), nonblank(trCd) ? trCd.trim() : null);
    }

    /**
     * w_ja020c.srw wue_retrieve 명세:
     * 1) dddw = 'F57' 이거나 xx_jm_cd가 비어 있으면 jm_cd = '%'로 조회
     * 2) xx_jm_cd가 지정된 경우 d_ja020c1 조회 후, 0건이고 ib_managedata(ymd >= workDate)이면
     *    SR_JA021C 프로시저 호출 후 재조회
     */
    @Transactional
    public Ja020cDataDto query(Ja020cFilterDto filter) {
        require(filter != null && nonblank(filter.getCorpGr()) && filter.getYmd() != null && nonblank(filter.getDddw()),
                "회사그룹, 영업일자, 거래코드를 확인하십시오.");

        String corpGr = filter.getCorpGr().trim();
        LocalDate ymd = filter.getYmd();
        String trCd = filter.getDddw().trim();
        LocalDate workDate = LocalDate.parse(workDateService.getWorkDateOrDefault(corpGr));
        boolean canManage = !ymd.isBefore(workDate);

        String resolvedJmCd = nonblank(filter.getXxJmCd()) ? filter.getXxJmCd().trim() : "";
        if (resolvedJmCd.isEmpty() && nonblank(filter.getKoscomCd())) {
            String foundJm = mapper.selectJmCdByKoscomCd(filter.getKoscomCd().trim(), filter.getDancGb());
            if (nonblank(foundJm)) {
                resolvedJmCd = foundJm.trim();
            }
        }

        String targetJmCd;
        List<Ja020cDto> rows;
        if ("F57".equalsIgnoreCase(trCd) || !nonblank(resolvedJmCd)) {
            targetJmCd = "%";
            rows = mapper.selectList(corpGr, ymd, trCd, targetJmCd);
        } else {
            targetJmCd = resolvedJmCd;
            rows = mapper.selectList(corpGr, ymd, trCd, targetJmCd);
            if (rows.isEmpty() && canManage) {
                Map<String, Object> spParams = new HashMap<>();
                spParams.put("corpGr", corpGr);
                spParams.put("ymd", Date.valueOf(ymd));
                spParams.put("trCd", trCd);
                spParams.put("koscomCd", nonblank(filter.getKoscomCd()) ? filter.getKoscomCd().trim() : "");
                spParams.put("jmCd", targetJmCd);
                spParams.put("brokYmd", null);
                spParams.put("pMsg", null);

                mapper.callSrJa021c(spParams);
                Object outMsg = spParams.get("pMsg");
                String msgStr = (outMsg != null) ? outMsg.toString().trim() : "";
                if ("Y".equalsIgnoreCase(msgStr)) {
                    rows = mapper.selectList(corpGr, ymd, trCd, targetJmCd);
                } else if (!msgStr.isEmpty()) {
                    throw new IllegalArgumentException(msgStr);
                } else {
                    rows = List.of();
                }
            }
        }

        for (Ja020cDto row : rows) {
            if (row.getIsNew() == null) {
                row.setIsNew(false);
            }
            row.setOriginalFundCd(row.getFundCd());
            row.setOriginalJmCd(row.getJmCd());
        }

        Ja020cDataDto dataDto = new Ja020cDataDto();
        dataDto.setRows(rows);
        dataDto.setWorkDate(workDate);
        dataDto.setCanManage(canManage);
        dataDto.setResolvedJmCd(resolvedJmCd);
        return dataDto;
    }

    /**
     * SJT0FS 단일 테이블 CUD (JPA Entity & Dirty Checking)
     */
    @Transactional
    public int save(Ja020cSaveDto saveDto, String userId) {
        require(saveDto != null && saveDto.getFilter() != null && saveDto.getRows() != null,
                "저장할 자료를 확인하십시오.");

        Ja020cFilterDto filter = saveDto.getFilter();
        require(nonblank(filter.getCorpGr()) && filter.getYmd() != null && nonblank(filter.getDddw()),
                "필수 조회 조건이 누락되었습니다.");

        String corpGr = filter.getCorpGr().trim();

        int count = 0;
        for (Ja020cDto dto : saveDto.getRows()) {
            if (dto == null) continue;

            String fundCd = nonblank(dto.getFundCd()) ? dto.getFundCd().trim() : "";
            require(!fundCd.isEmpty(), "펀드번호를 입력하십시오.");

            String trCd = nonblank(dto.getTrCd()) ? dto.getTrCd().trim() : filter.getDddw().trim();
            LocalDate trYmd = dto.getTrYmd() != null ? dto.getTrYmd() : filter.getYmd();

            String jmCd = nonblank(dto.getJmCd()) ? dto.getJmCd().trim() : "";
            if (jmCd.isEmpty()) {
                if ("F57".equalsIgnoreCase(trCd)) {
                    jmCd = fundCd;
                } else if (nonblank(filter.getXxJmCd())) {
                    jmCd = filter.getXxJmCd().trim();
                }
            }
            require(!jmCd.isEmpty(), "종목코드가 누락되었습니다.");

            String typeTrench = nonblank(dto.getTypeTrench()) ? dto.getTypeTrench().trim() : "00:";
            BigDecimal bsType = dto.getBsType() != null ? dto.getBsType() : BigDecimal.ZERO;

            String originalFundCd = nonblank(dto.getOriginalFundCd()) ? dto.getOriginalFundCd().trim() : fundCd;
            String originalJmCd = nonblank(dto.getOriginalJmCd()) ? dto.getOriginalJmCd().trim() : jmCd;
            Sjt0fsId originalId = new Sjt0fsId(
                    corpGr, trYmd, trCd, originalFundCd, originalJmCd, typeTrench, bsType);
            Sjt0fs entity = jpaRepository.findById(originalId);

            boolean isDeleted = Boolean.TRUE.equals(dto.getIsDeleted()) || "D".equalsIgnoreCase(dto.getRowStatus());
            boolean isNew = Boolean.TRUE.equals(dto.getIsNew()) || "C".equalsIgnoreCase(dto.getRowStatus());

            if (isDeleted) {
                if (entity != null) {
                    jpaRepository.remove(entity);
                    count++;
                }
                continue;
            }

            if (isNew) {
                require(entity == null, "동일한 펀드번호의 입금 내역이 이미 존재합니다.");
                entity = new Sjt0fs();
                entity.setCorpGr(corpGr);
                entity.setTrYmd(trYmd);
                entity.setTrCd(trCd);
                entity.setFundCd(fundCd);
                entity.setJmCd(jmCd);
                entity.setTypeTrench(typeTrench);
                entity.setBsType(bsType);
                entity.setKoscomCd(nonblank(dto.getKoscomCd()) ? dto.getKoscomCd().trim()
                        : (nonblank(filter.getKoscomCd()) ? filter.getKoscomCd().trim() : null));
                entity.setHwakjAek(zero(dto.getHwakjAek()));
                entity.setSuryAek(zero(dto.getSuryAek()));
                entity.setDanga(zero(dto.getDanga()));
                entity.setChuiAek(dto.getChuiAek());
                entity.setTax(dto.getTax());
                entity.setSusu(dto.getSusu());
                entity.setCyType(nonblank(dto.getCyType()) ? dto.getCyType().trim() : "2");
                entity.setBrokYmd(dto.getBrokYmd() != null ? dto.getBrokYmd()
                        : (filter.getBaedGisanYmd() != null ? filter.getBaedGisanYmd() : trYmd));
                entity.setUpdUser(userId);
                jpaRepository.persist(entity);
                count++;
            } else {
                require(entity != null, "수정할 입금 내역을 찾을 수 없습니다. 다시 조회해 주십시오.");
                boolean keyChanged = !originalFundCd.equals(fundCd) || !originalJmCd.equals(jmCd);
                if (keyChanged) {
                    Sjt0fsId changedId = new Sjt0fsId(corpGr, trYmd, trCd, fundCd, jmCd, typeTrench, bsType);
                    require(jpaRepository.findById(changedId) == null, "동일한 펀드번호의 입금 내역이 이미 존재합니다.");

                    Sjt0fs replacement = copyWithChangedKey(entity, fundCd, jmCd);
                    jpaRepository.remove(entity);
                    jpaRepository.flush();
                    entity = replacement;
                    jpaRepository.persist(entity);
                }

                // PB taborder가 있는 편집 컬럼(fund_cd, sury_aek, danga)만 변경한다.
                entity.setSuryAek(zero(dto.getSuryAek()));
                entity.setDanga(zero(dto.getDanga()));
                if (dto.getKoscomCd() != null) {
                    entity.setKoscomCd(dto.getKoscomCd().trim());
                }
                entity.setUpdUser(userId);
                count++;
            }
        }
        return count;
    }

    private static Sjt0fs copyWithChangedKey(Sjt0fs source, String fundCd, String jmCd) {
        Sjt0fs target = new Sjt0fs();
        target.setCorpGr(source.getCorpGr());
        target.setTrYmd(source.getTrYmd());
        target.setTrCd(source.getTrCd());
        target.setFundCd(fundCd);
        target.setJmCd(jmCd);
        target.setTypeTrench(source.getTypeTrench());
        target.setBsType(source.getBsType());
        target.setKoscomCd(source.getKoscomCd());
        target.setHwakjAek(source.getHwakjAek());
        target.setSuryAek(source.getSuryAek());
        target.setDanga(source.getDanga());
        target.setChuiAek(source.getChuiAek());
        target.setTax(source.getTax());
        target.setSusu(source.getSusu());
        target.setUpdUser(source.getUpdUser());
        target.setCyType(source.getCyType());
        target.setBrokYmd(source.getBrokYmd());
        return target;
    }

    private static BigDecimal zero(BigDecimal val) {
        return val != null ? val : BigDecimal.ZERO;
    }

    private static boolean nonblank(String val) {
        return val != null && !val.isBlank();
    }

    private static void require(boolean condition, String message) {
        if (!condition) {
            throw new IllegalArgumentException(message);
        }
    }
}

