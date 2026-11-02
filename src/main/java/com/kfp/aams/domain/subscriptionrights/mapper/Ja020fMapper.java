package com.kfp.aams.domain.subscriptionrights.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.Map;

@Mapper
public interface Ja020fMapper {

    void callSrJa020f(Map<String, Object> params);
}

