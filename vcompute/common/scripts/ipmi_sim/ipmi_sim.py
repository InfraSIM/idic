#!/usr/bin/python
'''
*********************************************************
Copyright @ 2015 EMC Corporation All Rights Reserved
*********************************************************
'''

# To run a threaded server, import threading and other libraries to help out.
import SocketServer
import threading
import sdr
import common
import sshsrv
import time, os, string, subprocess

SSH_IP_BINDING = '0.0.0.0'
SSH_PORT_BINDING = 9300
SERVERPROTOCOL = 'ssh'
SERVERTYPE = 'threaded'


class TestSSHHandler(sshsrv.SSHHandler):
    # -- Override items to customize the server --
    WELCOME = 'You have connected to the test server.'
    PROMPT = "IPMI_SIM> "

    def session_start(self):
        '''Called after the user successfully logs in.'''
        pass

    def session_end(self):
        '''Called after the user logs off.'''
        pass

    def writeerror(self, text):
        '''Called to write any error information (like a mistyped command).
        Add a splash of color using ANSI to render the error text in red.
        see http://en.wikipedia.org/wiki/ANSI_escape_code'''
        pass

sensor_thread_list = []

def sel_clear_thread():
    check_sel = "ipmitool -H localhost -U admin -P admin sel list".split(' ')
    while True:
        pipe = subprocess.Popen(check_sel, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
        if len(pipe[0]) > 0:
            buf = pipe[0]
        else:
            buf = pipe[1]

        if string.find(buf, "no entries") > 0:
            os.system("ipmitool -H localhost -U admin -P admin raw 0x0a 0x44 0x01 0x00 0x02 0x69 0x4F 0x1F 0x57 0x20 0x00 0x04 0x10 0xf3 0x6f 0x02 0xff 0xff")

        time.sleep(1)

def spawn_sensor_thread():
    t = threading.Thread(target=sel_clear_thread)
    sensor_thread_list.append(t)
    t.start()

    for sensor_obj in sdr.sensor_list:
        if sensor_obj.get_event_type() == "threshold":
            t = threading.Thread(target=sensor_obj.execute)
            t.setDaemon(True)
            sensor_thread_list.append(t)
            common.logger.info('spawn a thread for sensor ' +
                               sensor_obj.get_name())
            t.start()


def free_resource():
    # close telnet session
    # common.close_telnet_session()

    # join the sensor thread
    for sensor_obj in sdr.sensor_list:
        sensor_obj.set_mode("user")
        # set quit flag
        sensor_obj.set_quit(True)
        # acquire the lock that before notify
        sensor_obj.condition.acquire()
        sensor_obj.condition.notify()
        sensor_obj.condition.release()

    for thread in sensor_thread_list:
        thread.join()

if __name__ == '__main__':

    # initialize logging
    common.init_logger()
    # open telnet session to IPMI simulator
    # common.open_telnet_session()

    # parse the sdrs and build all sensors
    sdr.parse_sdrs()

    # running thread for each threshold based sensor
    spawn_sensor_thread()

    if SERVERTYPE == 'threaded':
        # Single threaded server - only one session at a time
        class TelnetServer(SocketServer.TCPServer):
            allow_reuse_address = True

        server = TestSSHHandler(port=SSH_PORT_BINDING)

    common.logger.info("Starting %s %s server at port %d.  (Ctrl-C to stop)" %
                       (SERVERTYPE, SERVERPROTOCOL, SSH_PORT_BINDING))

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        free_resource()
        common.logger.info("Server shut down.")
