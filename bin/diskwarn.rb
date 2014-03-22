#!/usr/bin/ruby -w

# == Synopsis
#    Checks if your running out of disk space
#    and sends you an email if you are.

# == Author
#    Pedro Carvalho, incude at gmail dot com

require "net/smtp"

# Constants
DISKS = ["/dev/sda2","/dev/sda1"]
ULIMIT = 95

class Checkdisk

 def getline(fs,df)
     df.each {|line| if line[fs]: return line.split(/\s+/) end}
 end
 
 def sendmail(line)
     email = "From: admin <root@localhost>\n" +
             "Subject: diskwarn - Disk(s) Out of Space\n\n" +
             "Filesystem: " + line[1] + " Mounted on " + line[5] + "\n" +
             "Available: " + line[3] + "\n" +
             "In Use: " + line[1]  + "\n\n"

     Net::SMTP.start('localhost', 25)  do |smtp|
      smtp.send_message email, 'root@localhost', 'root@localhost'
     end
 end

 def run
     out = `df -h`
     for i in 0..DISKS.length-1
	line = getline(DISKS[i],out)
        if line[4].chop.to_i >= ULIMIT
	    sendmail(line) 
        end
     end
 end

end

app = Checkdisk.new
app.run
