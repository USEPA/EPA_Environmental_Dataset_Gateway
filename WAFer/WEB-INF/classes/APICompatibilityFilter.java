import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class APICompatibilityFilter
  implements Filter
{
  private static final Log logger = LogFactory.getLog(APICompatibilityFilter.class);
  private FilterConfig config;

  public void init(FilterConfig paramFilterConfig)
    throws ServletException
  {
    this.config = paramFilterConfig;
    logger.info("initializing APICompatibilityFilter");
  }

  public void doFilter(ServletRequest paramServletRequest, ServletResponse paramServletResponse, FilterChain paramFilterChain)
    throws IOException, ServletException
  {
    HttpServletRequest localHttpServletRequest = (HttpServletRequest)paramServletRequest;
    String str = localHttpServletRequest.getServletPath();
    if (str.contains("/internal/"))
    {
      paramFilterChain.doFilter(paramServletRequest, paramServletResponse);
    } else if (str.endsWith(".xml")) {
      paramServletResponse.setContentType("text/xml");
      this.config.getServletContext().getRequestDispatcher("/get.jsp").include(paramServletRequest, paramServletResponse);
    } else {
      paramServletResponse.setContentType("text/html");
      this.config.getServletContext().getRequestDispatcher("/index.jsp").include(paramServletRequest, paramServletResponse);
    }
  }

  public void destroy() {
    logger.info("destroying APICompatibilityFilter");
  }
}
