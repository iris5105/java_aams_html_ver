package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.ProposalCommentDto;
import com.kfp.aams.domain.daily.dto.ProposalMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ProposalMapper {
    List<ProposalMasterDto> selectProposalMasterList(@Param("corpGr") String corpGr);
    List<ProposalCommentDto> selectProposalCommentList(@Param("corpGr") String corpGr, 
                                                      @Param("ymd") String ymd, 
                                                      @Param("proposer") String proposer);
}
