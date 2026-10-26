package com.kfp.aams.domain.subscriptionrights.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020aT1Dto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020aT4aDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020aT4bDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020aT5Dto;
import com.kfp.aams.domain.subscriptionrights.mapper.Ja020aMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

/**
 * W_JA020A (공모청약 종목 및 배정등록) 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Ja020aService {

    private final Ja020aMapper ja020aMapper;
    private final WorkDateService workDateService;

    /**
     * 회사그룹별 기준 작업일자 조회 (SZX0AA.HYUN_YMD 연동)
     */
    @Transactional(readOnly = true)
    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * [탭1] 기본정보 종목 목록 조회 (d_ja020a_t1a)
     */
    @Transactional(readOnly = true)
    public List<Ja020aT1Dto> getT1List(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return ja020aMapper.selectT1List(corpGr.trim());
    }

    /**
     * [탭1] 기본정보 단건 등록/수정
     */
    @Transactional
    public Ja020aT1Dto saveT1(Ja020aT1Dto dto, String loginUser) {
        if (dto == null) {
            throw new IllegalArgumentException("저장할 기본정보 데이터가 없습니다.");
        }

        String operator = (loginUser != null && !loginUser.isBlank()) ? loginUser : "admin";
        dto.setIpUser(operator);

        boolean isNew = Boolean.TRUE.equals(dto.getIsNew()) || dto.getJcJoin() == null || dto.getJcJoin().isBlank();

        if (isNew) {
            String nextJcJoin = ja020aMapper.selectNextJcJoin();
            dto.setJcJoin(nextJcJoin);
            ja020aMapper.insertSjg1jc(dto);
            log.info("W_JA020A 탭1 공모종목 등록 완료 - jcJoin: {}, jmNm: {}", nextJcJoin, dto.getJmNm());
        } else {
            ja020aMapper.updateSjg1jc(dto);
            log.info("W_JA020A 탭1 공모종목 수정 완료 - jcJoin: {}, jmNm: {}", dto.getJcJoin(), dto.getJmNm());
        }

        return dto;
    }

    /**
     * [탭1] 기본정보 종목 삭제
     */
    @Transactional
    public void deleteT1(String jcJoin) {
        if (jcJoin == null || jcJoin.isBlank()) {
            throw new IllegalArgumentException("삭제할 종목의 관리번호(jcJoin)가 없습니다.");
        }

        int count = ja020aMapper.countSjg1fc(jcJoin.trim());
        if (count > 0) {
            throw new IllegalStateException("해당 종목으로 신청/청약된 펀드 내역이 " + count + "건 존재하여 삭제할 수 없습니다.");
        }

        ja020aMapper.deleteSjg1jc(jcJoin.trim());
        log.info("W_JA020A 탭1 공모종목 삭제 완료 - jcJoin: {}", jcJoin);
    }

    /**
     * [탭2] 배정등록 - 청약종목 목록 조회 (d_ja020a_t4a)
     */
    @Transactional(readOnly = true)
    public List<Ja020aT4aDto> getT4aList(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return ja020aMapper.selectT4aList(corpGr.trim());
    }

    /**
     * [탭2] 배정등록 - 펀드별 청약/배정 상세 목록 조회 (d_ja020a_t4b)
     */
    @Transactional(readOnly = true)
    public List<Ja020aT4bDto> getT4bList(String corpGr, String jcJoin, String jgTrCoCd, LocalDate ymd, LocalDate workDate) {
        if (corpGr == null || corpGr.isBlank() || jcJoin == null || jcJoin.isBlank()) {
            return Collections.emptyList();
        }
        return ja020aMapper.selectT4bList(corpGr.trim(), jcJoin.trim(), jgTrCoCd, ymd, workDate);
    }

    /**
     * [탭2] 배정등록 저장 (헤더 및 펀드별 상세 저장)
     */
    @Transactional
    public int saveT4(Ja020aT4aDto t4aData, List<Ja020aT4bDto> t4bList, String loginUser) {
        String operator = (loginUser != null && !loginUser.isBlank()) ? loginUser : "admin";
        int totalSaved = 0;

        // 1) 상단 청약종목 헤더 저장 (sjg1jc_tr MERGE)
        if (t4aData != null && t4aData.getJcJoin() != null && !t4aData.getJcJoin().isBlank()) {
            t4aData.setIpUser(operator);
            ja020aMapper.mergeSjg1jcTr(t4aData);
            totalSaved++;
        }

        // 2) 하단 펀드별 배정 목록 저장 (sjg1fc UPDATE)
        if (t4bList != null && !t4bList.isEmpty()) {
            for (Ja020aT4bDto item : t4bList) {
                item.setIpUser(operator);
                totalSaved += ja020aMapper.updateSjg1fc(item);
            }
        }

        log.info("W_JA020A 탭2 배정정보 저장 완료 - 건수: {}", totalSaved);
        return totalSaved;
    }

    /**
     * [탭3] 수요예측참여총괄표 종목 목록 조회 (d_ja020a_t5)
     */
    @Transactional(readOnly = true)
    public List<Ja020aT5Dto> getT5List(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return ja020aMapper.selectT5List(corpGr.trim());
    }
}
