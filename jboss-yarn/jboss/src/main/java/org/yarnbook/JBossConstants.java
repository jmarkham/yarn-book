package org.yarnbook;


public interface JBossConstants {

	public static final String JBOSS_VERSION = "jboss-as-7.1.1.Final";
	
	public static final String JBOSS_DIST_PATH = "hdfs://yarn1.apps.hdp:9000/apps/jboss/dist/jboss-as-7.1.1.Final.tar.gz";
	
	public static final String JBOSS_SYMLINK = "jboss";
	
	public static final String JBOSS_YARN = "jboss-yarn";
	
	public static final String  JBOSS_MGT_REALM = "ManagementRealm";
	
	public static final String JBOSS_CONTAINER_LOG_DIR = "/var/log/hadoop/yarn";
	
	public static final String JBOSS_ON_YARN_APP = "JBossApp.jar";
	
	public static final String COMMAND_CHAIN = " && ";
}
