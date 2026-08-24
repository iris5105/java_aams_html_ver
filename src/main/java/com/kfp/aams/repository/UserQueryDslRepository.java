package com.kfp.aams.repository;

import com.kfp.aams.dto.UserDto;
import com.kfp.aams.entity.QFwUserMst;
import com.kfp.aams.util.QueryDslUtils;
import com.kfp.aams.entity.QSzx0aa;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

@Slf4j
@Repository
@RequiredArgsConstructor
public class UserQueryDslRepository {

    private final JPAQueryFactory queryFactory;

    /**
     * FW_USER_MST + SZX0AA LEFT JOIN QueryDSL 로그인 사용자 및 회사 정보 조회
     */
    public UserDto findUserForLogin(String userId, String password) {
        QFwUserMst user = QFwUserMst.fwUserMst;
        QSzx0aa company = QSzx0aa.szx0aa;

        return queryFactory
                .select(Projections.fields(UserDto.class,
                        user.userId.as("userId"),
                        user.userNm.as("userNm"),
                        QueryDslUtils.nvlToChar(user.outYmd, "yyyymmdd", "99991231").as("outYmd"),
                        QueryDslUtils.nvl(user.deptCd, "A420").as("deptCd"),
                        user.deptNm.as("deptNm"),
                        QueryDslUtils.toChar(user.inYmd, "yyyymmdd").as("inYmd"),
                        user.corpGr.as("corpGr"),
                        user.adminYn.as("adminYn"),
                        user.managerYn.as("managerYn"),
                        user.watchmanYn.as("watchmanYn"),
                        user.bookmarkStart.as("bookmarkStart"),
                        user.lastConnect.as("lastConnect"),
                        QueryDslUtils.toDecrypts(user.encEMail).as("encEMail"),
                        company.companyName.as("companyName"),
                        company.hyunYmd.as("hyunYmd"),
                        company.customerGr.as("customerGr")))
                .from(user)
                .leftJoin(company).on(company.corpGr.eq(user.corpGr))
                .where(user.outYmd.isNull()
                        .and(user.userId.eq(userId).or(user.encEMail.eq(QueryDslUtils.toEncrypts(userId))))
                        .and(user.encPw.eq(QueryDslUtils.toEncrypts(password))))
                .fetchFirst();
    }

    /**
     * FW_USER_MST 테이블에서 USER_ID (또는 enc_e_mail)로 corp_gr 및 admin_yn 조회
     */
    public UserDto findUserRoleAndCorpGr(String userId) {
        QFwUserMst user = QFwUserMst.fwUserMst;

        return queryFactory
                .select(Projections.fields(UserDto.class,
                        user.userId.as("userId"),
                        user.corpGr.as("corpGr"),
                        user.adminYn.as("adminYn")))
                .from(user)
                .where(user.outYmd.isNull()
                        .and(user.userId.eq(userId).or(user.encEMail.eq(QueryDslUtils.toEncrypts(userId)))))
                .fetchFirst();
    }
}
