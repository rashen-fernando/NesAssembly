import binascii
import numpy as np
content = open('our.bkg', 'rb')
data = content.read(255*16)
#print(data)
hexadecimal = binascii.hexlify(data)
#self.file_content.setText(hexadecimal)
hexa = hexadecimal.decode()
