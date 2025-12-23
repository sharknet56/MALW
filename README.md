# Malware project (MCYBERS UPC)
This is a project for the Malware course from the Master in cybersecurity of UPC (Polytechnic University of Catalonia)

## Disclaimer
This project is only used for educational purposes

## Motivation
We are master's students at a certain university and we are reaching the end of the semester. There is one specific subject, called Application Security, where the exam went notably bad. The end of the semester is approaching, and if the second exam is going to be as bad as the first one, we will be in big trouble! For this reason we need a way to ensure a good grade in the exams. We are 5 students with the same goal, to upgrade our grades so we don’t fail the subject, so we created our own hacker group.

At this point, we learned some malicious cybersecurity tricks (from a certain course in the master’s degree). We developed a plan to attack the university's infrastructure. The main target is Atenea, where grades are posted. We know that Atenea is based on an LMS called Moodle. If we manage to compromise the Moodle server, we can change our grade for the rest of the master's program, or even charge students to change their grades, steal exams or future assignments, etc. Basically, easy money! :D

Everything is planned, the attack will be executed on Christmas, when Atenea admins are relaxed (at home and probably drunk). Teachers won’t be paying much attention either (probably because they're drunk too). So nobody will notice if some student's grade suddenly transforms to a 10 (or a 9.8 to be more stealthy).

## Attack architecture
Investigating on how to compromise a moodle server, we found a RCE (Remote Code Execution) exploit that is suitable to gain access into the moodle server. But this vulnerability requires the capability to add/update questions in Moodle (permissions that a teacher has).

Therefore, we need a way to supplant the teacher’s identity. How are we going to do it? With social engineering. We will send malware disguised as an assignment report to the teacher through Atenea. The teacher will download and open the document and it will trigger an RCE exploit in the teacher’s machine.

Once we are able to execute arbitrary code in the teacher’s machine, we make him execute the exploit to Moodle with his permissions.

Finally, with RCE in Moodle we will send a reverse shell back to us, the attackers, be able to control the system remotely.

The steps are:
1. Delivery of malicious word document: The document is disguised as an assignment and delivered via moodle submission. The document will trigger a Remote Code Execution (RCE) on the teacher's machine.
2. Fooling the teacher: Teacher downloads the document from moodle, and opens it, therefore triggering a RCE in his machine.
3. Teacher's machine compromised: The teacher's machine will execute a prepared payload that will exploit the RCE vulnerability in moodle (Using his account).
4. Remote shell: We trick the moodle server to send us a reverse shell, using the RCE exploit executed by the teacher.

Upon establishing the reverse shell, we gained access to the server with the privileges of the web service user (www-data). However, this user has restricted permissions and cannot modify system configurations or access the core Moodle database credentials required to inject a new administrator. To overcome this, we performed a Privilege Escalation phase.

As a final step to achieve our goal, we create an admin user in Atenea that is able to impersonate any user in Atenea. We will use this user to change our grades in Application Security :). Merry Christmas Application Security!

For this final step we have a php script (createadminuser.php) to create the admin user inside Moodle/Atenea.

## Exploits used
- [CVE-2022-30190](https://nvd.nist.gov/vuln/detail/cve-2022-30190), the code for the exploit is based on the PoC in [here](https://github.com/JohnHammond/msdt-follina)
- [CVE-2024-43425](https://nvd.nist.gov/vuln/detail/CVE-2024-43425), the code for the exploit is based on the PoC in [here](https://www.exploit-db.com/exploits/52350)
- [CVE-2025-32463](https://nvd.nist.gov/vuln/detail/CVE-2025-32463), the code for the exploit is based on the PoC in [here](https://www.exploit-db.com/exploits/52352)
- [Singularity rootkit](https://github.com/MatheuZSecurity/Singularity)
