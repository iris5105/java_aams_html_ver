package com.kfp.aams.security;

import com.kfp.aams.domain.auth.dto.UserDto;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Collections;

@Getter
public class UserPrincipal implements UserDetails {

    private final String userId; // user_id
    private final String userNm; // user_nm
    private final String outYmd; // out_ymd (yyyymmdd)
    private final String deptCd; // dept_cd
    private final String deptNm; // dept_nm
    private final String inYmd; // in_ymd (yyyymmdd)
    private final String corpGr; // CORP_GR
    private final String adminYn; // admin_yn
    private final String managerYn; // manager_yn
    private final String watchmanYn; // watchman_yn
    private final String bookmarkStart; // bookmark_start
    private final String lastConnect; // last_connect
    private final String encEMail;
    private final String companyName;
    private final String hyunYmd;
    private final String customerGr;
    private final String password;
    private final Collection<? extends GrantedAuthority> authorities;

    public UserPrincipal(String userId, String corpGr) {
        this(userId, null, null, null, null, null, corpGr, null, null, null, null, null, null, null, null, null, "",
                Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER")));
    }

    public UserPrincipal(UserDto userDto) {
        this(
                userDto != null ? userDto.getUserId() : null,
                userDto != null ? userDto.getUserNm() : null,
                userDto != null ? userDto.getOutYmd() : "99991231",
                userDto != null ? userDto.getDeptCd() : "A420",
                userDto != null ? userDto.getDeptNm() : null,
                userDto != null ? userDto.getInYmd() : null,
                userDto != null ? userDto.getCorpGr() : null,
                userDto != null ? userDto.getAdminYn() : "N",
                userDto != null ? userDto.getManagerYn() : "N",
                userDto != null ? userDto.getWatchmanYn() : "N",
                userDto != null ? userDto.getBookmarkStart() : null,
                userDto != null ? userDto.getLastConnect() : null,
                userDto != null ? userDto.getEncEMail() : null,
                userDto != null ? userDto.getCompanyName() : null,
                userDto != null ? userDto.getHyunYmd() : null,
                userDto != null ? userDto.getCustomerGr() : null,
                "",
                Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER")));
    }

    public UserPrincipal(String userId, String userNm, String outYmd, String deptCd, String deptNm,
            String inYmd, String corpGr, String adminYn, String managerYn,
            String watchmanYn, String bookmarkStart, String lastConnect,
            String encEMail, String companyName, String hyunYmd, String customerGr, String password,
            Collection<? extends GrantedAuthority> authorities) {
        this.userId = userId;
        this.userNm = userNm;
        this.outYmd = outYmd != null ? outYmd : "99991231";
        this.deptCd = deptCd != null ? deptCd : "A420";
        this.deptNm = deptNm;
        this.inYmd = inYmd;
        this.corpGr = corpGr;
        this.adminYn = adminYn;
        this.managerYn = managerYn;
        this.watchmanYn = watchmanYn;
        this.bookmarkStart = bookmarkStart;
        this.lastConnect = lastConnect;
        this.encEMail = encEMail;
        this.companyName = companyName;
        this.hyunYmd = hyunYmd;
        this.customerGr = customerGr;
        this.password = password;
        this.authorities = authorities;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return userId;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    public UserDto getUserDto() {
        return UserDto.builder()
                .userId(this.userId)
                .userNm(this.userNm)
                .outYmd(this.outYmd)
                .deptCd(this.deptCd)
                .deptNm(this.deptNm)
                .inYmd(this.inYmd)
                .corpGr(this.corpGr)
                .adminYn(this.adminYn)
                .managerYn(this.managerYn)
                .watchmanYn(this.watchmanYn)
                .bookmarkStart(this.bookmarkStart)
                .lastConnect(this.lastConnect)
                .encEMail(this.encEMail)
                .companyName(this.companyName)
                .hyunYmd(this.hyunYmd)
                .customerGr(this.customerGr)
                .build();
    }
}
