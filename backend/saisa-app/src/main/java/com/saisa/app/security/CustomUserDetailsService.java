package com.saisa.app.security;

import com.saisa.common.tenant.Tenant;
import com.saisa.common.tenant.TenantRepository;
import com.saisa.common.user.User;
import com.saisa.common.user.UserRepository;
import java.util.List;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

/**
 * Custom UserDetailsService - login ke waqt tenant code + username se user fetch.
 *
 * NOTE: Spring Security ka standard UserDetailsService sirf username leta hai.
 * Hum tenantCode ko UsernamePasswordAuthenticationToken ke details mein
 * pack karte hain (LoginRequest ke through).
 *
 * Login endpoint ye service use karta hai via AuthenticationManager.
 */
@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;
    private final TenantRepository tenantRepository;

    public CustomUserDetailsService(UserRepository userRepository,
                                    TenantRepository tenantRepository) {
        this.userRepository = userRepository;
        this.tenantRepository = tenantRepository;
    }

    /**
     * The 'username' here is actually "tenantCode:username" concatenated.
     * The login controller builds it before calling authenticate().
     */
    @Override
    public UserDetails loadUserByUsername(String compositeUsername) throws UsernameNotFoundException {
        int idx = compositeUsername.indexOf(':');
        if (idx < 0) {
            throw new UsernameNotFoundException("Malformed username: missing tenant code");
        }
        String tenantCode = compositeUsername.substring(0, idx);
        String username = compositeUsername.substring(idx + 1);

        Tenant tenant = tenantRepository.findByTenantCode(tenantCode)
            .orElseThrow(() -> new UsernameNotFoundException("Tenant not found: " + tenantCode));

        User user = userRepository.findByTenantIdAndUsername(tenant.getId(), username)
            .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));

        List<GrantedAuthority> authorities = user.getRoles().stream()
            .map(r -> (GrantedAuthority) new SimpleGrantedAuthority("ROLE_" + r.getRoleCode()))
            .toList();

        return org.springframework.security.core.userdetails.User.builder()
            .username(compositeUsername)
            .password(user.getPasswordHash())
            .authorities(authorities)
            .accountLocked(user.isLocked())
            .disabled(!user.isActive())
            .build();
    }
}

