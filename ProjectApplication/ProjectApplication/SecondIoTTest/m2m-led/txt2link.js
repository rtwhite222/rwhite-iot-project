function txt2link(txt) {
    txt=txt.replace("YRDKRX63N", "<a target='_blank' href='http://www.renesas.com/products/tools/introductory_evaluation_tools/renesas_demo_kits/yrdkrx63n/index.jsp'>YRDKRX63N</a>");
    txt=txt.replace("Arch Pro", "<a target='_blank' href='http://www.seeedstudio.com/depot/Arch-Pro-p-1677.html'>Arch Pro</a>");
    txt=txt.replace("EK-TM4C1294XL", "<a target='_blank' href='http://www.ti.com/tool/ek-tm4c1294xl'>EK-TM4C1294XL</a>");
    txt=txt.replace("mbed", "<a target='_blank' href='https://developer.mbed.org/users/wini/code/SharkSSL-Lite/'>mbed</a>");
    console.log(txt);
    return txt;
};
