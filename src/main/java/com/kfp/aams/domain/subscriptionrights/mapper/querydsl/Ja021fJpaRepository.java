package com.kfp.aams.domain.subscriptionrights.mapper.querydsl;

import com.kfp.aams.domain.subscriptionrights.dto.Ja021fDetailDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021fMasterDto;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
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
        String sql = """
                SELECT t1.tr_ymd, t1.tr_cd, t1.balh_co, t1.jeungj_mth, t1.baej_mth,
                       t1.balh_ga, t1.woos_balh_ga, t1.jekyng_rt, t1.woos_jekyng_rt,
                       t1.baed_gisan_ymd, t1.cheng_ymd, t1.krak_ymd, t1.baej_gijun_ymd,
                       t1.jukm_nabib_ymd, t1.sinj_jaew, t1.ilban_balh_jusu,
                       t1.woos_balh_jusu, f_balh_nm('', t1.balh_co)
                  FROM sjt0jk t1
                 WHERE t1.tr_cd = :trCd
                 ORDER BY t1.tr_ymd DESC
                """;
        List<Object[]> rows = entityManager.createNativeQuery(sql)
                .setParameter("trCd", trCd)
                .getResultList();
        return rows.stream().map(this::toMasterDto).toList();
    }

    public List<Ja021fDetailDto> selectDetail(String corpGr, String ymd, String balhCo, String jeungjMth) {
        String sql = """
                SELECT t1.corp_gr, t1.ymd, t1.balh_co, t1.jeungj_mth, t1.fund_cd,
                       t1.old_jm_cd, t1.new_jm_cd, t1.krak_jusu, t1.krak_chui_aek,
                       t1.baej_jusu, t1.baej_rt, t1.balh_ga, t1.chui_aek,
                       t1.gosi_jekyng_ymd, t1.chg_bf_jusu, t1.chg_bf_rt,
                       t1.chg_bf_balh_ga, t1.chg_chui_aek, t1.chg_bf_ymd,
                       t1.sury_ymd, t1.sury_jusu, t1.cheng_ymd, t1.cheng_jusu,
                       t1.haeji_fund, t1.haeji_ymd, t1.type_trench, t1.bs_type,
                       t1.upd_user, f_fund_nm(t1.corp_gr, t1.fund_cd)
                  FROM sjt0j1 t1
                 WHERE t1.corp_gr LIKE :corpGr
                   AND t1.ymd = TO_DATE(REPLACE(:ymd, '-', ''), 'YYYYMMDD')
                   AND t1.balh_co = :balhCo
                   AND t1.jeungj_mth = :jeungjMth
                 ORDER BY t1.fund_cd
                """;
        List<Object[]> rows = entityManager.createNativeQuery(sql)
                .setParameter("corpGr", corpGr)
                .setParameter("ymd", ymd)
                .setParameter("balhCo", balhCo)
                .setParameter("jeungjMth", jeungjMth)
                .getResultList();
        return rows.stream().map(this::toDetailDto).toList();
    }

    private Ja021fMasterDto toMasterDto(Object[] row) {
        return Ja021fMasterDto.builder()
                .trYmd(toLocalDate(row[0]))
                .trCd(asString(row[1]))
                .balhCo(asString(row[2]))
                .jeungjMth(asString(row[3]))
                .baejMth(asString(row[4]))
                .balhGa(asBigDecimal(row[5]))
                .woosBalhGa(asBigDecimal(row[6]))
                .jekyngRt(asBigDecimal(row[7]))
                .woosJekyngRt(asBigDecimal(row[8]))
                .baedGisanYmd(toLocalDate(row[9]))
                .chengYmd(toLocalDate(row[10]))
                .krakYmd(toLocalDate(row[11]))
                .baejGijunYmd(toLocalDate(row[12]))
                .jukmNabibYmd(toLocalDate(row[13]))
                .sinjJaew(asString(row[14]))
                .ilbanBalhJusu(asBigDecimal(row[15]))
                .woosBalhJusu(asBigDecimal(row[16]))
                .xxBalhCo(asString(row[17]))
                .build();
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
