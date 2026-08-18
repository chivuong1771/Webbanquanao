package poly.java.Utils;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.ServletContext;

import java.util.Properties;

public class EmailUtils {

    private static final String FROM_EMAIL = "minhnhut07112002@gmail.com";
    private static final String APP_PASSWORD = "vxhnsfwuzkaacmkh";
    private static final String FROM_NAME = "Fashion Shop"; // Tên hiển thị người gửi

    public static void sendEmail(ServletContext servletContext, String toEmail, String subject, String bodyContent) throws Exception {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);


        message.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME, "UTF-8"));

        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setContent(bodyContent, "text/html; charset=UTF-8");

        Transport.send(message);
    }
}