import requests
import logging
from Legobot.Lego import Lego

logger = logging.getLogger(__name__)
base_url = 'https://raw.githubusercontent.com/voxpupuli/'

class Audit(Lego):
    def listening_for(self, message):
        return message['text'].split()[0] == '!msync'

    def handle(self,message):
        arg = None
        if len(message['text'].split()) == 1:
            # No args supplied
            msync_blob = requests.get(base_url + 'modulesync_config/master/moduleroot/.msync.yml')
            msync_text = msync_blob.text
            self.reply(message, msync_text.strip('\n'))
        elif len(message['text'].split()) > 1:
            arg = message['text'].split()[1]

        if arg == "getver":
            try:
                modname = message['text'].split()[2]
                #msync_ver = requests.get('https://raw.githubusercontent.com/voxpupuli/puppet-sftp_jail/master/.msync.yml')
                msync_ver = requests.get(base_url + modname + '/master/.msync.yml')
                msync_ver = msync_ver.text
                logger.debug('modname variable:' + modname)
                logger.debug('msync_ver variable: ' + msync_ver)
                self.reply(message, msync_ver.strip('\n'))
            except:
                self.reply(message, 'Could not find a module to query :/')

        return

    def get_name(self):
        return 'msync'

    def get_help(self):
        return 'Discover information about the status of modulesync on managed repositories. Usage: !msync [olderthan a.b.c]'
