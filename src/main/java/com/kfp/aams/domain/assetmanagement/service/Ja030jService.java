package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja030jDetailDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030jDto;
import com.kfp.aams.domain.assetmanagement.mapper.Ja030jMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja030jService {

    private final Ja030jMapper ja030jMapper;

    /**
     * 채권 잔고/수익 상세 목록 조회 (파워빌더 wue_retrieve)
     */
    public List<Ja030jDto> getJa030jList(String corpGr, String fymd, String tymd, String gubun, String cashCd, String hjCd, String fundCd) {
        String cleanFymd = fymd != null ? fymd.replaceAll("[^0-9]", "") : "";
        String cleanTymd = tymd != null ? tymd.replaceAll("[^0-9]", "") : "";

        return ja030jMapper.selectJa030jList(
                corpGr != null ? corpGr.trim() : "",
                cleanFymd,
                cleanTymd,
                gubun != null ? gubun.trim() : "1",
                cashCd != null ? cashCd.trim() : "%",
                hjCd != null ? hjCd.trim() : "",
                fundCd != null ? fundCd.trim() : ""
        );
    }

    /**
     * 채권 상세 정보 조회 (파워빌더 dw_detail::ue_retrieve)
     * 직결 SQL 우선 조회 (프로시저 내 수식 컬럼 별칭 누락으로 인한 null 매핑 방어) -> 실패 시 프로시저 호출
     */
    public Ja030jDetailDto getJa030jDetail(String corpGr, String ymd, String fundCd, String jmCd) {
        String cleanYmd = ymd != null ? ymd.replaceAll("[^0-9]", "") : "";
        String cleanCorpGr = corpGr != null ? corpGr.trim() : "";
        String cleanFundCd = fundCd != null ? fundCd.trim() : "";
        String cleanJmCd = jmCd != null ? jmCd.trim() : "";

        // 1) 직결 SQL 우선 실행 (모든 컬럼 명시적 Alias 매핑으로 hmChuiAek, hmAekm 등 누락 원천 방어)
        try {
            Ja030jDetailDto detail = ja030jMapper.selectJa030jDetail(cleanCorpGr, cleanYmd, cleanFundCd, cleanJmCd);
            if (detail != null) {
                return detail;
            }
        } catch (Exception e) {
            log.warn("[Ja030jService] selectJa030jDetail 직결 쿼리 실행 실패, 프로시저로 대체 시도합니다: {}", e.getMessage());
        }

        // 2) 프로시저 KFP.SR_JA030J 호출 Fallback
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("corpGr", cleanCorpGr);
            params.put("ymd", cleanYmd);
            params.put("fundCd", cleanFundCd);
            params.put("jmCd", cleanJmCd);

            ja030jMapper.callSrJa030j(params);

            @SuppressWarnings("unchecked")
            List<Ja030jDetailDto> list = (List<Ja030jDetailDto>) params.get("rSet");
            if (list != null && !list.isEmpty()) {
                return list.get(0);
            }
        } catch (Exception e) {
            log.warn("[Ja030jService] SR_JA030J 프로시저 호출 실패: {}", e.getMessage());
        }

        return null;
    }
}

