package com.kfp.aams;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class AamsApplicationTests {

	@org.springframework.beans.factory.annotation.Autowired
	private com.kfp.aams.domain.menu.service.MenuService menuService;

	@Test
	void contextLoads() {
	}
}
