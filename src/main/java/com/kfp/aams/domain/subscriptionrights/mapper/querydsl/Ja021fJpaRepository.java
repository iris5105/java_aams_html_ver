package com.kfp.aams.domain.subscriptionrights.mapper.querydsl;

import com.kfp.aams.domain.subscriptionrights.dto.Ja021fDetailDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021fMasterDto;
import com.kfp.aams.domain.subscriptionrights.entity.Sjt0jk;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class Ja021fJpaRepository {
    private final EntityManager entityManager;

    public List<Ja021fMasterDto> selectSimpleMaster(String trCd) {
        return entityManager.createQuery("""
                        select master, function('f_balh_nm', '', master.balhCo)
                          from Sjt0jk master
                         where master.trCd = :trCd
                         order by master.trYmd desc
                        """, Object[].class)
                .setParameter("trCd", trCd)
                .getResultList()
                .stream()
                .map(this::toMasterDto)
                .toList();
    }

    public List<Ja021fDetailDto> selectDetail(
            String corpGr, LocalDate ymd, String balhCo, String jeungjMth) {
        return entityManager.createQuery("""
                        select detail.corpGr, detail.ymd, detail.balhCo, detail.jeungjMth,
                               detail.fundCd, detail.oldJmCd, detail.newJmCd, detail.krakJusu,
                               detail.krakChuiAek, detail.baejJusu, detail.baejRt, detail.balhGa,
                               detail.chuiAek, detail.gosiJekyngYmd, detail.chgBfJusu,
                               detail.chgBfRt, detail.chgBfBalhGa, detail.chgChuiAek,
                               detail.chgBfYmd, detail.suryYmd, detail.suryJusu, detail.chengYmd,
                               detail.chengJusu, detail.haejiFund, detail.haejiYmd,
                               detail.typeTrench, detail.bsType, detail.updUser,
                               function('f_fund_nm', detail.corpGr, detail.fundCd)
                          from Sjt0j1 detail
                         where detail.corpGr like :corpGr
                           and detail.ymd = :ymd
                           and detail.balhCo = :balhCo
                           and detail.jeungjMth = :jeungjMth
                         order by detail.corpGr, detail.fundCd
                        """, Object[].class)
                .setParameter("corpGr", corpGr)
                .setParameter("ymd", ymd)
                .setParameter("balhCo", balhCo)
                .setParameter("jeungjMth", jeungjMth)
                .getResultList()
                .stream()
                .map(this::toDetailDto)
                .toList();
    }

    private Ja021fMasterDto toMasterDto(Object[] row) {
        Ja021fMasterDto dto = new Ja021fMasterDto();
        BeanUtils.copyProperties((Sjt0jk) row[0], dto);
        dto.setXxBalhCo(asString(row[1]));
        return dto;
    }

    private Ja021fDetailDto toDetailDto(Object[] row) {
        return Ja021fDetailDto.builder()
                .corpGr(asString(row[0]))
                .ymd(toLocalDate(row[1]))
                .balhCo(asString(row[2]))
                .jeungjMth(asString(row[3]))
                .fundCd(asString(row[4]))
                .oldJmCd(asString(row[5]))
                .newJmCd(asString(row[6]))
                .krakJusu(asBigDecimal(row[7]))
                .krakChuiAek(asBigDecimal(row[8]))
                .baejJusu(asBigDecimal(row[9]))
                .baejRt(asBigDecimal(row[10]))
                .balhGa(asBigDecimal(row[11]))
                .chuiAek(asBigDecimal(row[12]))
                .gosiJekyngYmd(toLocalDate(row[13]))
                .chgBfJusu(asBigDecimal(row[14]))
                .chgBfRt(asBigDecimal(row[15]))
                .chgBfBalhGa(asBigDecimal(row[16]))
                .chgChuiAek(asBigDecimal(row[17]))
                .chgBfYmd(toLocalDate(row[18]))
                .suryYmd(toLocalDate(row[19]))
                .suryJusu(asBigDecimal(row[20]))
                .chengYmd(toLocalDate(row[21]))
                .chengJusu(asBigDecimal(row[22]))
                .haejiFund(asString(row[23]))
                .haejiYmd(toLocalDate(row[24]))
                .typeTrench(asString(row[25]))
                .bsType(asString(row[26]))
                .updUser(asString(row[27]))
                .fundNm(asString(row[28]))
                .build();
    }

    private static String asString(Object value) {
        return value == null ? null : String.valueOf(value);
    }

    private static BigDecimal asBigDecimal(Object value) {
        if (value == null) return null;
        if (value instanceof BigDecimal decimal) return decimal;
        if (value instanceof Number number) return new BigDecimal(number.toString());
        return new BigDecimal(String.valueOf(value));
    }

    private static LocalDate toLocalDate(Object value) {
        if (value == null) return null;
        if (value instanceof LocalDate date) return date;
        if (value instanceof java.sql.Date date) return date.toLocalDate();
        if (value instanceof Timestamp timestamp) return timestamp.toLocalDateTime().toLocalDate();
        if (value instanceof java.util.Date date) {
            return date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        }
        String text = String.valueOf(value);
        return LocalDate.parse(text.length() >= 10 ? text.substring(0, 10) : text);
    }
}
