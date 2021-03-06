<%@ page import="java.awt.*,java.awt.image.*,java.util.*,javax.imageio.*" pageEncoding="gbk"%>
<%@ page import="java.io.OutputStream"%>
<%--<%@ page import="java.awt.geom.AffineTransform" %>--%>

<%--	采用JPG格式的图片验证码	--%>

<%!Color getRandColor(int fc, int bc)	//随机生成图片中rgb的值
{
    Random random = new Random();
    if (fc > 255) {
        fc = 255;
    }

    if (bc > 255) {
        bc = 255;
    }

    int r = fc + random.nextInt(bc - fc);

    int g = fc + random.nextInt(bc - fc);

    int b = fc + random.nextInt(bc - fc);

    return new Color(r, g, b);
}
%>

<%
    try
    {
        response.setHeader("Pragma", "No-cache");

        response.setHeader("Cache-Control", "no-cache");

        response.setDateHeader("Expires", 0);

        int width = 80, height = 32;

        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);

        OutputStream os = response.getOutputStream();

        Graphics2D g = (Graphics2D)image.getGraphics();

        Random random = new Random();

        // 设置画笔的颜色
        g.setColor(getRandColor(200, 250));

        // 画图，生成干扰图片
        g.fillRect(0, 0, width, height);

        //字体等样式
        g.setFont(new Font("Times New Roman", Font.PLAIN, 24));

        g.setColor(getRandColor(160, 200));
        //生成图像内部的干扰线条
        for (int i = 0; i < 155; i++)
        {
            int x = random.nextInt(width);
            int y = random.nextInt(height);
            int xl = random.nextInt(12);
            int yl = random.nextInt(12);

            //绘制干扰线条
            g.drawLine(x, y, x + xl, y + yl);
        }

        String sRand = "";
        //生成4为随机的、有彩色值得验证码
        for (int i = 0; i < 4; i++)
        {
            //生成一位验证码的值
            String rand;
            switch (random.nextInt(3))
            {
                case 0:
                    rand = String.valueOf(random.nextInt(10));
                    break;
                case 1:
                    rand = String.valueOf((char)(random.nextInt(26)+65));
                    break;
                case 2:
                    rand = String.valueOf((char)(random.nextInt(26)+97));
                    break;
                    default:
                    rand = "?";
            }
            sRand += rand;

            g.setColor(new Color(20 + random.nextInt(110), 20 + random.nextInt(110), 20 + random.nextInt(110)));

            //设置倾斜角
            int degree = random.nextInt(60);
            g.rotate((degree-30) * Math.PI / 180,18 * i + random.nextInt(3)+2, 20 + random.nextInt(10));

            //对生成的验证码值进行颜色设置，已进行干扰
            g.drawString(rand, 18 * i + random.nextInt(3)+2, 20 + random.nextInt(10));
            g.rotate(-(degree-30) * Math.PI / 180,18 * i + random.nextInt(3)+2, 20 + random.nextInt(10));
        }

        session.setAttribute("checkCode_inSession", sRand);

        g.dispose();

        //生成JPEG格式的图片验证码
        ImageIO.write(image, "gif", os);

        os.flush();
        os.close();

//        os = null;

        // 用来将缓冲区的数据立即输出到浏览器当中
        response.flushBuffer();

        /*	两句关键代码	*/
        out.clear();

//        out = pageContext.pushBody();
    }
    catch (IllegalStateException e)
    {
        System.out.println(e.getMessage());
        e.printStackTrace();
    }
%>