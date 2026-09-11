package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja010gDto;
import com.kfp.aams.domain.daily.mapper.Ja010gMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja010gService {

    private final Ja010gMapper ja010gMapper;

    @Transactional(readOnly = true)
    public List<Ja010gDto> selectJa010gList(String corpGr, String ymd) {
        List<Ja010gDto> list = ja010gMapper.selectJa010gList(corpGr, ymd);
        for (Ja010gDto dto : list) {
            BigDecimal yeStock = dto.getYeStockAek() != null ? dto.getYeStockAek() : BigDecimal.ZERO;
            BigDecimal uhStock = dto.getUhStockAek() != null ? dto.getUhStockAek() : BigDecimal.ZERO;
            BigDecimal uhStockGongmo = dto.getUhStockGongmo() != null ? dto.getUhStockGongmo() : BigDecimal.ZERO;
            BigDecimal gaek = dto.getGaek() != null ? dto.getGaek() : BigDecimal.ZERO;

            BigDecimal yeBond = dto.getYeBondAek() != null ? dto.getYeBondAek() : BigDecimal.ZERO;
            BigDecimal uhBond = dto.getUhBondAek() != null ? dto.getUhBondAek() : BigDecimal.ZERO;

            BigDecimal yeTot = dto.getYeTotAek() != null ? dto.getYeTotAek() : BigDecimal.ZERO;
            BigDecimal misuBaed = dto.getMisuBaedAek() != null ? dto.getMisuBaedAek() : BigDecimal.ZERO;
            BigDecimal gsonik = dto.getGsonik() != null ? dto.getGsonik() : BigDecimal.ZERO;
            BigDecimal uhNav = dto.getUhNav() != null ? dto.getUhNav() : BigDecimal.ZERO;
            BigDecimal mijigub = dto.getMijigubAek() != null ? dto.getMijigubAek() : BigDecimal.ZERO;

            // 주식차액: ye_stock_aek - uh_stock_aek + uh_stock_gongmo + gaek
            BigDecimal stockCha = yeStock.subtract(uhStock).add(uhStockGongmo).add(gaek);
            dto.setStockCha(stockCha);

            // 채권차액: ye_bond_aek - uh_bond_aek
            BigDecimal bondCha = yeBond.subtract(uhBond);
            dto.setBondCha(bondCha);

            // 순자산차액: (ye_tot_aek + misu_baed_aek + gsonik + uh_stock_gongmo) - (uh_nav + mijigub_aek)
            BigDecimal navCha = yeTot.add(misuBaed).add(gsonik).add(uhStockGongmo).subtract(uhNav.add(mijigub));
            dto.setNavCha(navCha);
        }
        return list;
    }

    @Transactional
    public int updateConfirmYmd(String corpGr, String ymd) {
        return ja010gMapper.updateConfirmYmd(corpGr, ymd);
    }

    @Transactional(readOnly = true)
    public String getWorkDate(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return null;
        }
        return ja010gMapper.selectWorkDate(corpGr);
    }
}
