### Introduction ###

Let be clear, with redtamarin the goal is to run on the command-line,<br>
so you are more likely to have a shell running some <code>*.abc</code> file<br>
or being an executable that embed this <code>*.abc</code> file.<br>
<br>
My philosophy is: if you are an executable you have full access to everything,<br>
whether you use ActionScript, Python, Java, PHP, C#, C++, C, or whatever<br>
to <b><code>format c:</code></b> does not really matter.<br>
<br>
But that does not mean we will ignore completely the security problems,<br>
for one in some case we will try to emulate the what the Flash Player or AIR do<br>
(ex: emule Flash Player 9 web profile to test some code),<br>
second, the same as Adobe, we don't want malformed <code>*.abc</code> to execute malicious code<br>
because of a buffer overflow,<br>
and third when redtamarin will focus to run on the server side we want it to be as secure<br>
as any other server side language (Python, PHP for ex).<br>
<br>
Last but not least, our goal with tamarin is to provide tools for the Flash Community,<br>
and we plan to have some focusing on security, wether some analysis tool that warn you<br>
about some "login","password" strings in your SWF or some other that would automate<br>
obfuscation and/or encryption, anyway expect some parts of redtamarin to be all about security.<br>
<br>
<br>
<h3>Ressources</h3>

<b>links:</b>
<ul><li><a href='https://www.flashsec.org'>flashsec</a> wiki dedicated to Adobe Flash/Flex/AIR and ActionScript security<br>
</li><li><a href='https://www.flashsec.org/wiki/Simple_AS3_Decompiler_Using_Tamarin'>Simple AS3 Decompiler Using Tamarin</a> (flashsec)<br>
</li><li><a href='http://blog.48bits.com/2010/02/15/debuggeando-codigo-jiteado-de-actionscript/'>Debugging ActionScript JITed code</a> by Ariel E. Coronel</li></ul>

<b>documents:</b>
<ul><li>(PDF) <a href='http://documents.iss.net/whitepapers/IBM_X-Force_WP_final.pdf'>Application-Specific Attacks: Leveraging the ActionScript Virtual Machine</a> By Mark Dowd (X-Force Researcher IBM Internet Security Systems)<br>
</li><li>(PPT) <a href='http://www.owasp.org/images/b/bb/Hacking_The_World_With_Flash.ppt'>Hacking The World With Flash: Analyzing Vulnerabilities in Flash and the Risk of Exploitation</a> by Paul Craig (Security-Assessment.com / OWASP 29/2008)