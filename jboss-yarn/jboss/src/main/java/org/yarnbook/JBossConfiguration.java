package org.yarnbook;

import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.GnuParser;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;

public class JBossConfiguration implements JBossConstants {

	private static String jbossHome;
	private static String jbossServerGroupName;
	private static String jbossServerName;
	private static String jbossAdminUserName;
	private static String jbossAdminUserPassword;
	private static String jbossDomainController;
	private static String jbossHostName;
	private static int portOffset;

	private static final Logger LOG = Logger.getLogger(JBossConfiguration.class
			.getName());

	private Options opts;

	/**
	 * Constructor that creates the configuration
	 */
	public JBossConfiguration() {

		opts = new Options();
		opts.addOption("home", true, "JBoss AS home directory");
		opts.addOption("server_group", true, "JBoss AS server group name");
		opts.addOption("server", true, "JBoss AS server name");
		opts.addOption("port_offset", true,
				"JBoss AS server instance port number offset");
		opts.addOption("admin_user", true,
				"Initial admin user added to ManagementRealm");
		opts.addOption("admin_password", true,
				"Initial admin user password added to ManagementRealm");
		opts.addOption("domain_controller", true,
				"Host for domain control");
		opts.addOption("host", true,
				"Hostname of JBoss AS instance");
	}

	public static void main(String[] args) {

		JBossConfiguration conf = new JBossConfiguration();

		try {
			conf.init(args);

			Util.addAdminUser(jbossHome, jbossAdminUserName,
					jbossAdminUserPassword, JBOSS_MGT_REALM);
			Util.addDomainServerGroup(jbossHome, jbossServerGroupName);
			Util.addDomainServer(jbossHome, jbossServerGroupName,
					jbossServerName, portOffset);
			Util.addDomainController(jbossHome, jbossDomainController,
					jbossHostName, portOffset);

		} catch (Exception e) {
			LOG.log(Level.SEVERE, "Problem configuring JBoss AS", e);
		}
	}

	private void init(String[] args) throws ParseException {

		CommandLine cliParser = new GnuParser().parse(opts, args);

		jbossHome = cliParser.getOptionValue("home");
		jbossServerGroupName = cliParser.getOptionValue("server_group");
		jbossServerName = cliParser.getOptionValue("server");
		jbossAdminUserName = cliParser.getOptionValue("admin_user");
		jbossAdminUserPassword = cliParser.getOptionValue("admin_password");
		portOffset = Integer.parseInt(cliParser.getOptionValue("port_offset"));
		jbossDomainController = cliParser.getOptionValue("domain_controller");
		jbossHostName = cliParser.getOptionValue("host");
	}
}
