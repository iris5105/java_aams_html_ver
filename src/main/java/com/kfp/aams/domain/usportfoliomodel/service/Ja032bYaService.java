package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bDdDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bDdFundDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bYaBulkRegisterRequest;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bYaStockDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032bYaMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 관심종목 변동성 추이 (W_JA032B_YA) 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Ja032bYaService {

    private final Ja032bYaMapper ja032bYaMapper;
    private final Ja032bDdService ja032bDdService;

    /**
     * 작업기준일자 조회
     */
    public String getWorkDate(String corpGr) {
        return ja032bDdService.getWorkDate(corpGr);
    }

    /**
     * 펀드 목록 조회 (dw_c dddw)
     */
    public List<Ja032bDdFundDto> getFundList(String corpGr, String ymd) {
        return ja032bDdService.getFundList(corpGr, ymd);
    }

    /**
     * 포트 번호 목록 조회 (dw_c dddw2)
     */
    public List<String> getPortList(String corpGr, String fundCd, String ymd) {
        if (corpGr == null || corpGr.isBlank() || fundCd == null || fundCd.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        List<String> list = ja032bYaMapper.selectPortList(corpGr, fundCd, ymd);
        return list != null ? list : Collections.emptyList();
    }

    /**
     * 포트 정보(FYMD, TT) 조회
     */
    public Map<String, Object> getPortInfo(String corpGr, String fundCd, String portNum, String ymd) {
        if (corpGr == null || fundCd == null || portNum == null || ymd == null) {
            return Collections.emptyMap();
        }
        Map<String, Object> info = ja032bYaMapper.selectPortInfo(corpGr, fundCd, portNum, ymd);
        return info != null ? info : Collections.emptyMap();
    }

    /**
     * 관심종목 변동성 추이 목록 조회 (d_ja032b_ya.srd)
     */
    public List<Ja032bYaStockDto> getStockList(String corpGr, String ymd, String fundCd, String portNum) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }

        String fymd = ymd;
        String tt = "1";

        if (fundCd != null && !fundCd.isBlank() && portNum != null && !portNum.isBlank()) {
            Map<String, Object> portInfo = ja032bYaMapper.selectPortInfo(corpGr, fundCd, portNum, ymd);
            if (portInfo != null) {
                if (portInfo.get("FYMD") != null) {
                    fymd = String.valueOf(portInfo.get("FYMD"));
                }
                if (portInfo.get("TT") != null) {
                    tt = String.valueOf(portInfo.get("TT"));
                }
            }
        }

        List<Ja032bYaStockDto> list = ja032bYaMapper.selectStockList(corpGr, fymd, ymd, tt);
        return list != null ? list : Collections.emptyList();
    }

    /**
     * 종목 일별현황 상세 목록 조회 (d_ja032b_dd.srd / d_ja032b_dd_krx.srd)
     */
    public List<Ja032bDdDetailDto> getDetailList(String corpGr, String jmCd, String fymd, String tymd) {
        return ja032bDdService.getDetailList(corpGr, jmCd, fymd, tymd);
    }

    /**
     * 선택종목 일괄 등록 (cb_1 로직)
     */
    @Transactional
    public Map<String, Object> bulkRegister(Ja032bYaBulkRegisterRequest request) {
        Map<String, Object> result = new HashMap<>();

        if (request == null || request.getItems() == null || request.getItems().isEmpty()) {
            result.put("success", false);
            result.put("message", "종목을 선택 후 일괄등록 처리 하십시오.");
            return result;
        }

        String corpGr = request.getCorpGr();
        String ymd = request.getYmd();
        String fundCd = request.getFundCd();
        String portNum = request.getPortNum();

        if (corpGr == null || corpGr.isBlank() || fundCd == null || fundCd.isBlank() || portNum == null || portNum.isBlank()) {
            result.put("success", false);
            result.put("message", "필수 파라미터(회사그룹, 펀드, 포트)가 누락되었습니다.");
            return result;
        }

        Integer maxCol = ja032bYaMapper.selectMaxCol(corpGr, fundCd, ymd, portNum);
        int currentCol = (maxCol != null) ? maxCol : 0;

        int insertedCount = 0;
        int skippedCount = 0;

        for (Ja032bYaBulkRegisterRequest.StockItem item : request.getItems()) {
            String jmCd = item.getJmCd();
            String ovrsExcgCd = item.getOvrsExcgCd();

            if (jmCd == null || jmCd.isBlank()) {
                continue;
            }

            int exists = ja032bYaMapper.countUspm(corpGr, fundCd, ymd, portNum, jmCd);
            if (exists > 0) {
                skippedCount++;
                continue;
            }

            currentCol++;
            ja032bYaMapper.insertUspm(corpGr, ymd, fundCd, portNum, jmCd, currentCol, ovrsExcgCd);
            insertedCount++;
        }

        result.put("success", true);
        result.put("insertedCount", insertedCount);
        result.put("skippedCount", skippedCount);
        result.put("message", "선택한 종목을 일괄등록 했습니다.\n(신규: " + insertedCount + "건, 중복제외: " + skippedCount + "건)");

        return result;
    }
}
