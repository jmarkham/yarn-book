package org.yarnbook;

import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.security.MessageDigest;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.codec.binary.Base64;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class Util {

	private static final char[] HEX_CHARS = new char[] { '0', '1', '2', '3',
			'4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

	private static final Logger LOG = Logger.getLogger(Util.class.getName());

	public static void addAdminUser(String jbossHome, String userId,
			String password, String realm) {

		String fileName = String.format(
				"%s%sdomain%sconfiguration%smgmt-users.properties", jbossHome,
				File.separator, File.separator, File.separator);
		LOG.info(String.format("Adding user %s in realm %s to %s", userId,
				realm, fileName));
		FileWriter fw = null;
		ByteArrayOutputStream baos = null;
		try {

			byte[] userNameArray = userId.getBytes("UTF-8");
			byte[] realmArray = realm.getBytes("UTF-8");
			byte[] passwordArray = password.getBytes("UTF-8");

			int requiredSize = userNameArray.length + realmArray.length
					+ passwordArray.length + 2;

			MessageDigest digest = MessageDigest.getInstance("MD5");
			baos = new ByteArrayOutputStream(requiredSize);
			baos.write(userNameArray);
			baos.write(":".getBytes());
			baos.write(realmArray);
			baos.write(":".getBytes());
			baos.write(passwordArray);

			byte[] hashedURP = digest.digest(baos.toByteArray());

			char[] converted = new char[hashedURP.length * 2];
			for (int i = 0; i < hashedURP.length; i++) {
				byte b = hashedURP[i];
				converted[i * 2] = HEX_CHARS[b >> 4 & 0x0F];
				converted[i * 2 + 1] = HEX_CHARS[b & 0x0F];
			}

			fw = new FileWriter(fileName, true);
			fw.write(String.format("%n%s=%s%n", userId,
					String.valueOf(converted)));

		} catch (Exception e) {
			LOG.log(Level.SEVERE, "Problem creating new admin user", e);
		} finally {
			closeCloseable(fw);
			closeCloseable(baos);
		}
	}

	public static void addDomainServerGroup(String jbossHome,
			String serverGroupName) {
		try {

			String fileName = String.format(
					"%s%sdomain%sconfiguration%sdomain.xml", jbossHome,
					File.separator, File.separator, File.separator);
			LOG.info(String.format("Adding server group %s to %s",
					serverGroupName, fileName));

			File file = new File(fileName);

			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document document = builder.parse(file);

			Element root = document.getDocumentElement();

			Element serverGroups = document.createElement("server-groups");

			Element serverGroup = document.createElement("server-group");
			serverGroup.setAttribute("name", serverGroupName);
			serverGroup.setAttribute("profile", "full-ha");

			Element jvm = document.createElement("jvm");
			jvm.setAttribute("name", "default");

			Element heap = document.createElement("heap");
			heap.setAttribute("size", "64m");
			heap.setAttribute("max-size", "512m");

			Element socketBindingGroup = document
					.createElement("socket-binding-group");
			socketBindingGroup.setAttribute("ref", "full-sockets");

			jvm.appendChild(heap);
			serverGroup.appendChild(jvm);
			serverGroup.appendChild(socketBindingGroup);
			serverGroups.appendChild(serverGroup);
			root.appendChild(serverGroups);

			TransformerFactory transformerFactory = TransformerFactory
					.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			DOMSource source = new DOMSource(document);
			StreamResult result = new StreamResult(file);

			transformer.transform(source, result);

		} catch (Exception e) {
			LOG.log(Level.SEVERE, "Problem creating new server", e);
		}
	}

	public static void addDomainServer(String jbossHome,
			String serverGroupName, String serverName, int portOffset) {
		try {
			String fileName = String.format(
					"%s%sdomain%sconfiguration%shost.xml", jbossHome,
					File.separator, File.separator, File.separator);
			LOG.info(String
					.format("Adding server %s in server group %s with port offset %s to %s",
							serverName, serverGroupName, portOffset, fileName));

			File file = new File(fileName);

			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document document = builder.parse(file);

			Element root = document.getDocumentElement();

			Element servers = document.createElement("servers");

			Element server = document.createElement("server");
			server.setAttribute("name", serverName);
			server.setAttribute("group", serverGroupName);

			Element socketBindings = document.createElement("socket-bindings");
			socketBindings.setAttribute("port-offset",
					String.valueOf(portOffset));

			server.appendChild(socketBindings);
			servers.appendChild(server);
			root.appendChild(servers);

			TransformerFactory transformerFactory = TransformerFactory
					.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			DOMSource source = new DOMSource(document);
			StreamResult result = new StreamResult(file);

			transformer.transform(source, result);

		} catch (Exception e) {
			LOG.log(Level.SEVERE, "Problem creating new server", e);
		}
	}

	public static void addDomainController(String jbossHome, String controller,
			String host, int portOffset) {
		try {

			String masterPassword = "master";
			String slavePassword = "slave";

			addAdminUser(jbossHome, "master", masterPassword,
					JBossConstants.JBOSS_MGT_REALM);
			addAdminUser(jbossHome, "slave", slavePassword,
					JBossConstants.JBOSS_MGT_REALM);

			String fileName = String.format(
					"%s%sdomain%sconfiguration%shost.xml", jbossHome,
					File.separator, File.separator, File.separator);
			LOG.info(String.format("Adding controller %s to %s", controller,
					fileName));

			File file = new File(fileName);

			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document document = builder.parse(file);

			Element root = document.getDocumentElement();

			Element domainController = document
					.createElement("domain-controller");

			if (controller.equals(host)) {
				Element local = document.createElement("local");
				domainController.appendChild(local);
				root.setAttribute("name", "master");
			} else {
				root.setAttribute("name", "slave");
				Element remote = document.createElement("remote");
				remote.setAttribute("host", hostToIP(controller));
				remote.setAttribute("port", String.valueOf(9999));
				remote.setAttribute("security-realm",
						JBossConstants.JBOSS_MGT_REALM);
				domainController.appendChild(remote);

				Element management = (Element) root.getElementsByTagName(
						"management").item(0);
				NodeList securityRealms = management
						.getElementsByTagName("security-realm");
				for (int i = 0; i < securityRealms.getLength(); i++) {

					Element securityRealm = (Element) securityRealms.item(i);
					if (securityRealm.getAttribute("name").equals(
							JBossConstants.JBOSS_MGT_REALM)) {

						Element serverIdentities = document
								.createElement("server-identities");
						Element secret = document.createElement("secret");

						String value = new String(
								Base64.encodeBase64(slavePassword.getBytes()));
						secret.setAttribute("value", value);
						serverIdentities.appendChild(secret);

						Node authentication = securityRealm
								.getElementsByTagName("authentication").item(0);
						securityRealm.insertBefore(serverIdentities,
								authentication);
					}
				}
			}

			Node interfaces = root.getElementsByTagName("interfaces").item(0);
			root.insertBefore(domainController, interfaces);

			TransformerFactory transformerFactory = TransformerFactory
					.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			DOMSource source = new DOMSource(document);
			StreamResult result = new StreamResult(file);

			transformer.transform(source, result);

		} catch (Exception e) {
			LOG.log(Level.SEVERE, "Problem creating domain controller", e);
		}
	}

	private static void closeCloseable(Closeable closeable) {
		if (closeable != null) {
			try {
				closeable.close();
			} catch (IOException e) {
				LOG.info("Problem closing closeable");
			}
		}
	}

	private static String hostToIP(String host) {
		String ipAddr = "";
		try {
			InetAddress inetAddr = InetAddress.getByName(host);

			byte[] addr = inetAddr.getAddress();

			for (int i = 0; i < addr.length; i++) {
				if (i > 0) {
					ipAddr += ".";
				}
				ipAddr += addr[i] & 0xFF;
			}
		} catch (UnknownHostException e) {
			LOG.log(Level.SEVERE, "Problem converting " + host
					+ " to IP address", e);
		}
		return ipAddr;
	}
}
