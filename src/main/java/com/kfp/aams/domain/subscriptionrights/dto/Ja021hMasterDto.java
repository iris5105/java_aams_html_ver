package com.kfp.aams.domain.subscriptionrights.dto;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
@Data public class Ja021hMasterDto {
 private LocalDate trYmd; private String trCd,balhCo,oldJmCd,oldDancGb,oldKoscomCd,newJmCd,newDancGb,newKoscomCd;
 private String jmCd,sjKoscomCd,sjJmCd,balhNm,oldJmNm,newJmNm,jmNm,koscomNm;
 private LocalDate closeYmd,hwakjYmd,krakYmd,baejGijunYmd,chengYmd;
 private BigDecimal balhGa,hwakjBalhGa,jonga; private String g00; private Integer pVisible;
}
