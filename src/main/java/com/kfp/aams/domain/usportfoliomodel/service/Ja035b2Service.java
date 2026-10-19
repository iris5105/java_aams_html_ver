package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja035b2Dto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja035b2Mapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja035b2Service {

    private final Ja035b2Mapper mapper;

    /**
     * 해외파생 매매내역 목록 조회
     */
    public List<Ja035b2Dto> getList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.trim().isEmpty()) {
            throw new IllegalArgumentException("회사그룹(corpGr)은 필수 파라미터입니다.");
        }
        if (ymd == null || ymd.trim().isEmpty()) {
            throw new IllegalArgumentException("기준일자(ymd)는 필수 파라미터입니다.");
        }
        return mapper.selectList(corpGr.trim(), ymd.trim());
    }

    /**
     * 종목 정보 단건 조회
     */
    public Map<String, Object> getItemInfo(String corpGr, String jmCd) {
        if (corpGr == null || corpGr.trim().isEmpty() || jmCd == null || jmCd.trim().isEmpty()) {
            return new HashMap<>();
        }
        return mapper.selectItemInfo(corpGr.trim(), jmCd.trim());
    }

    /**
     * 최종 영업일자(최신 거래일자) 조회
     */
    public String getWorkDate(String corpGr) {
        if (corpGr == null || corpGr.trim().isEmpty()) {
            return LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        }
        String latestYmd = mapper.selectLatestWorkDate(corpGr.trim());
        if (latestYmd == null || latestYmd.trim().isEmpty()) {
            return LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        }
        return latestYmd;
    }

    /**
     * 일괄 CUD 저장
     */
    @Transactional
    public Map<String, Object> saveList(String corpGr, String ymd, List<Ja035b2Dto> list, String userId) {
        if (corpGr == null || corpGr.trim().isEmpty()) {
            throw new IllegalArgumentException("회사그룹(corpGr)은 필수 파라미터입니다.");
        }
        if (ymd == null || ymd.trim().isEmpty()) {
            throw new IllegalArgumentException("기준일자(ymd)는 필수 파라미터입니다.");
        }

        Map<String, Object> result = new HashMap<>();
        if (list == null || list.isEmpty()) {
            result.put("success", true);
            result.put("message", "저장할 변경 내역이 없습니다.");
            result.put("insertedCount", 0);
            result.put("updatedCount", 0);
            result.put("deletedCount", 0);
            return result;
        }

        Long curMaxSeq = mapper.selectMaxTrSeq(corpGr.trim(), ymd.trim());
        if (curMaxSeq == null) curMaxSeq = 0L;

        int inserted = 0;
        int updated = 0;
        int deleted = 0;

        for (Ja035b2Dto item : list) {
            item.setCorpGr(corpGr.trim());
            if (item.getTrYmd() == null || item.getTrYmd().trim().isEmpty()) {
                item.setTrYmd(ymd.trim());
            }
            if (userId != null && !userId.trim().isEmpty()) {
                item.setUpdUser(userId.trim());
            }

            boolean isDel = Boolean.TRUE.equals(item.getIsDeleted()) || "D".equalsIgnoreCase(item.getRowStatus());
            boolean isNew = Boolean.TRUE.equals(item.getIsNew()) || "C".equalsIgnoreCase(item.getRowStatus());
            boolean isUpd = Boolean.TRUE.equals(item.getIsUpdated()) || "U".equalsIgnoreCase(item.getRowStatus());

            if (isDel) {
                if (item.getTrSeq() != null) {
                    mapper.deleteSyt1mg(corpGr.trim(), item.getTrYmd(), item.getTrSeq());
                    deleted++;
                }
            } else if (isNew) {
                curMaxSeq++;
                item.setTrSeq(curMaxSeq);
                mapper.insertSyt1mg(item);
                inserted++;
            } else if (isUpd) {
                mapper.updateSyt1mg(item);
                updated++;
            }
        }

        result.put("success", true);
        result.put("message", String.format("정상적으로 처리되었습니다. (등록: %d, 수정: %d, 삭제: %d)", inserted, updated, deleted));
        result.put("insertedCount", inserted);
        result.put("updatedCount", updated);
        result.put("deletedCount", deleted);
        return result;
    }
}
