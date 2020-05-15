import socket
host = socket.gethostbyname("localhost")
s = []
for i in range(7):
	s.append(socket.socket(socket.AF_INET, socket.SOCK_STREAM))


def hello(states):
	f = open("port_init", "r")
	port_num = f.readline().strip()
	PORT_MIN = int(port_num)
	f.close()

	done = states[-1]
	states = states[:-1]

	"""Test help"""
	print("Hello!")
	f = open("test", "w")
	f.write(str(type(states[0])) + "\n" + str(states[0]) + "\n")
	f.close()

	for i, each in enumerate(states):
		print(i)
		if i != 0:
			states = [states[-1]] + states[: -1]
		state_str = str(states + [done])[1: -1]
		port = PORT_MIN + i
		s[i].connect((host, port))
		s[i].sendall(state_str)
		# s.close()
	
	u_ret = []
	for i in range(len(states)):
		port = PORT_MIN + i
		# s.connect((host, port))
		# f = open("debug_2", "w")
		# f.write("Holllllllla: "+str(s[i].recv(1024))+"\n")
		# f.close()
		u_ret.append(float(str(s[i].recv(1024))))
		s[i].close()


	return u_ret