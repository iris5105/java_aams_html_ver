package com.kfp.aams.domain.subscriptionrights.service;
import com.kfp.aams.domain.subscriptionrights.dto.*; import com.kfp.aams.domain.subscriptionrights.mapper.Ja021hMapper;
import lombok.RequiredArgsConstructor; import org.springframework.stereotype.Service; import java.time.LocalDate; import java.util.List; import java.util.Map; import java.util.concurrent.ConcurrentHashMap;
@Service @RequiredArgsConstructor public class Ja021hService {
 private final Ja021hMapper mapper;
 private final Map<String, CachedDetail> detailCache = new ConcurrentHashMap<>();
 public List<Ja021hMasterDto> master(String tab,LocalDate date){return mapper.selectMaster(tab,date);}
 public List<Ja021hDetailDto> detail(String scope,String jmCd,String ymd){
  String key=scope+"|"+jmCd+"|"+ymd; long now=System.currentTimeMillis();
  CachedDetail cached=detailCache.get(key); if(cached!=null && now-cached.createdAt<1000)return cached.rows;
  List<Ja021hDetailDto> rows=mapper.selectDetail(scope,jmCd,ymd); detailCache.put(key,new CachedDetail(now,rows)); return rows;
 }
 private record CachedDetail(long createdAt,List<Ja021hDetailDto> rows) {}
}
