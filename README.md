# Malware project (MCYBERS UPC)
This is a project for the Malware course from the Master in cybersecurity of UPC (Polytechnic University of Catalonia)

## Disclaimer
This project is only for educational purposes

## The project
In this project we develop a malware with a set of exploits.
The idea of our project consists of compromising and taking control of a Moodle server.
The story we want to tell is that we are students of a school that uses Moodle as LMS. Then a teacher puts some homework for us, and opens a submission request on Moodle. And because we really hate doing homeworks, we decide to send a malicious document disguised as homework and hack Moodle.

The malicious document will be a word document that invokes the MSDT (Microsoft Support Diagnostic Tool) and exploits it to perform RCE (Remote Code Execution), the exploit is based on the CVE-2022-30190 and a PoC we found and tested that works on a Windows 10 and a local installation (an archived ISO image) of Office 2021 (The vulnerability is patched if you try to install Office from MS servers).

Then after the teacher opens the malicious Word document, he will see the MSDT window pop up. He will think it is a bit weird, but he just closes it. At this point, in the background we have already executed the next stage of our plan to hack Moodle.

This stage consists of exploiting a Moodle vulnerability based on CVE-2024-43425. The Moodle vulnerability requires the capability to add/update questions in Moodle, and this is the reason we need to execute the exploit from a user that has those permissions, like a teacher. We found a PoC in exploit DB, which we haven’t tested yet, but if it works we could have RCE on the Moodle server.

If everything worked at this point, we could have the Moodle server execute whatever we want, for example a reverse shell so we can control the server remotely.

Finally, the last step is to take full control of the server by escalating privileges using a sudo vulnerability, like CVE-2025-32463.

## Exploits
- [CVE-2022-30190](https://nvd.nist.gov/vuln/detail/cve-2022-30190), the code for the exploit is based on the PoC in [here](https://github.com/JohnHammond/msdt-follina)
- [CVE-2024-43425](https://nvd.nist.gov/vuln/detail/CVE-2024-43425), the code for the exploit is based on the PoC in [here](https://www.exploit-db.com/exploits/52350)
- [CVE-2025-32463](https://nvd.nist.gov/vuln/detail/CVE-2025-32463), the code for the exploit is based on the PoC in [here](https://www.exploit-db.com/exploits/52352)