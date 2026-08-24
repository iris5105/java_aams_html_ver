package com.kfp.aams.service;

import com.kfp.aams.dto.*;
import com.kfp.aams.mapper.HomeMapper;
import com.kfp.aams.repository.HomeQueryDslRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class HomeService {

    private final HomeQueryDslRepository queryDslRepository;
    private final HomeMapper homeMapper;

    /**
     * Tab 1 (dw_1 / d_home01): Single Table query via QueryDSL
     */
    public List<DayTrDto> getDayTrList(String corpGr) {
        String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        return queryDslRepository.findDayTrList(corpGr, today);
    }

    /**
     * Tab 2 - DW 2 (dw_2 / d_home02): Multi-table JOIN via MyBatis
     */
    public List<GyulAccountDto> getGyulAccountList(String corpGr) {
        return homeMapper.selectHome02List(corpGr);
    }

    /**
     * Tab 2 - DW 3 (dw_3 / d_home03): Multi-table JOIN via MyBatis
     */
    public List<RateChangeDto> getRateChangeList(String corpGr) {
        return homeMapper.selectHome03List(corpGr);
    }

    /**
     * Tab 3 (dw_4 / d_home04): Multi-table Subquery via MyBatis
     */
    public List<PublicStockDto> getPublicStockList(String corpGr) {
        return homeMapper.selectHome04List(corpGr);
    }

    /**
     * Tab 4 (dw_5 / d_home05): Multi-table JOIN via MyBatis
     */
    public List<SubscriptionDto> getSubscriptionList(String corpGr) {
        return homeMapper.selectHome05List(corpGr);
    }

    /**
     * Tab 5 (dw_6 / d_home06): Single Table query via QueryDSL
     */
    public List<ProposalDto> getProposalList(String corpGr) {
        return queryDslRepository.findProposalList(corpGr);
    }

    /**
     * Company List (SZX0AA): Single Table query via QueryDSL
     */
    public List<CompanyDto> getCompanyList() {
        return queryDslRepository.findCompanyList();
    }

    /**
     * Notice Component (uo_allnotice / d_home5_notice_1): Multi-table Subquery via MyBatis
     */
    public List<NoticeDto> getNoticeList(String userId) {
        return homeMapper.selectHome5NoticeList(userId != null ? userId : "GUEST");
    }

    /**
     * Dual-Axis Chart Component (uo_cht1 / dw_cht9): fw_day_chtdata via MyBatis
     */
    public List<ChtDataDto> getChtDataList(String corpGr, String ymd) {
        String targetYmd = (ymd != null && !ymd.isBlank()) ? ymd : LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        return homeMapper.selectChtDataList(corpGr, targetYmd);
    }
}
