package com.jesjobom.websocket;

import javax.servlet.ServletRegistration;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

/**
 * Configuration of this web app, replacing web.xml according Servlet Specification 3.0.
 *
 * @author jesjobom
 * @see http://download.oracle.com/otn-pub/jcp/servlet-3.0-fr-eval-oth-JSpec/servlet-3_0-final-spec.pdf chapter 4
 */
public class WebConfig extends AbstractAnnotationConfigDispatcherServletInitializer {

	@Override
	protected void customizeRegistration(ServletRegistration.Dynamic registration) {
		registration.setInitParameter("dispatchOptionsRequest", "true");
		registration.setAsyncSupported(true);
	}

	@Override
	protected Class<?>[] getRootConfigClasses() {
		return new Class<?>[]{};
	}

	@Override
	protected Class<?>[] getServletConfigClasses() {
		return new Class<?>[]{ WebsocketConfig.class };
	}

	@Override
	protected String[] getServletMappings() {
		return new String[]{"/"};
	}
}
