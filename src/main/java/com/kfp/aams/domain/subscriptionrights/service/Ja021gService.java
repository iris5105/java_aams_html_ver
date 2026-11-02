package com.kfp.aams.domain.subscriptionrights.service;

import com.kfp.aams.domain.subscriptionrights.dto.*;
import com.kfp.aams.domain.subscriptionrights.entity.Sjt0hkId;
import com.kfp.aams.domain.subscriptionrights.mapper.querydsl.Ja021gJpaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Service @RequiredArgsConstructor @Transactional(readOnly = true)
public class Ja021gService {
    private static final Map<String, String> CODES = Map.of(
            "t1", "G40", "t2", "G43", "t3", "G45", "t4", "G47",
            "t5", "G60", "t6", "G92", "t7", "G93");
    private final Ja021gJpaRepository repository;
    private final com.kfp.aams.domain.subscriptionrights.mapper.Ja021gMapper mapper;

    public String code(String tab) {
        String code = CODES.get(tab);
        if (code == null) throw new IllegalArgumentException("올바르지 않은 업무 탭입니다.");
        return code;
    }
    public List<Ja021gMasterDto> master(String tab, LocalDate workDate) {
        return repository.selectMaster(code(tab), workDate);
    }
    public List<Ja021gDetailDto> detail(String tab, String scope, LocalDate ymd, String habCo, String piHabCo) {
        return repository.selectDetail(scope, new Sjt0hkId(ymd, code(tab), habCo, piHabCo));
    }
    @Transactional
    public void save(Ja021gSaveDto request, String corpGr, boolean admin, LocalDate workDate) {
        String trCd = code(request.getTab());
        if (request.getMaster() == null || request.getDetail() == null)
            throw new IllegalArgumentException("저장할 자료가 올바르지 않습니다.");
        for (Ja021gMasterDto dto : request.getMaster()) {
            if (!dto.isNew() && !dto.isUpdated() && !dto.isDeleted()) continue;
            dto.setTrCd(trCd);
            var original = dto.getOriginal();
            if (!dto.isNew()) {
                if (original == null || !trCd.equals(original.getTrCd()) || original.getTrYmd() == null)
                    throw new IllegalArgumentException("기존 공시 키가 올바르지 않습니다.");
                if (original.getTrYmd().isBefore(workDate))
                    throw new IllegalArgumentException("업무일 이전 공시는 변경할 수 없습니다.");
                var entity = repository.find(original);
                if (entity == null) throw new IllegalArgumentException("공시를 다시 조회해 주세요.");
                if (dto.isDeleted()) { repository.delete(entity); continue; }
            } else if (dto.isDeleted()) continue;
            if (dto.getTrYmd() == null || dto.getTrYmd().isBefore(workDate))
                throw new IllegalArgumentException("공시일자는 업무일 이후여야 합니다.");
            if (List.of("t3", "t4", "t6").contains(request.getTab())) dto.setPiHabCo(dto.getHabCo());
            if (dto.getHabCo() == null || dto.getHabCo().isBlank()) dto.setHabCo(dto.getPiHabCo());
            if (dto.getHabCo() == null || dto.getPiHabCo() == null
                    || !dto.getHabCo().matches("[A-Za-z0-9]{1,5}") || !dto.getPiHabCo().matches("[A-Za-z0-9]{1,5}"))
                throw new IllegalArgumentException("발행기관 코드를 입력해 주세요.");
            if ((dto.isNew() || !dto.getTrYmd().equals(original.getTrYmd())) && "1".equals(mapper.selectStockHoliday(dto.getTrYmd())))
                throw new IllegalArgumentException("거래소 휴장일에는 등록할 수 없습니다.");
            var key = Ja021gJpaRepository.key(dto);
            if ((dto.isNew() || !key.equals(original)) && repository.find(key) != null)
                throw new IllegalArgumentException("동일한 공시가 이미 등록되어 있습니다.");
            if (dto.isNew()) repository.insert(dto); else repository.update(dto);
        }
        for (Ja021gDetailDto dto : request.getDetail()) {
            if (!dto.isUpdated()) continue;
            if (!trCd.equals(dto.getTrCd()) || (!admin && !corpGr.equals(dto.getCorpGr())))
                throw new IllegalArgumentException("변경할 수 없는 상세 내역입니다.");
            if (dto.getHabJusu() == null || dto.getHabJusu().signum() < 0 || dto.getHabJusu().stripTrailingZeros().scale() > 0)
                throw new IllegalArgumentException("대상주식수는 0 이상의 정수로 입력해 주세요.");
            repository.updateDetail(dto);
        }
    }
}

