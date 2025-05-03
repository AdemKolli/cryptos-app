import argparse
import json
import struct
import copy
import sys
def _long2bytes(n, blocksize=0):
    
    s = b''
    pack = struct.pack
    while n > 0:
       
        s = pack('<I', n & 0xffffffff) + s
        n = n >> 32
  
    for i in range(len(s)):
        if s[i] != 0:
            break
    else:
       
        s = b'\0'
        i = 0

    s = s[i:]

    if blocksize > 0 and len(s) % blocksize:
        s = (blocksize - len(s) % blocksize) * b'\0' + s

    return s

def _bytelist2long(data):
    
    imax = len(data) // 4
    hl = [0] * imax

    j = 0
    i = 0
    while i < imax:
        b0 = data[j]
        b1 = data[j+1] << 8
        b2 = data[j+2] << 16
        b3 = data[j+3] << 24
        hl[i] = b0 | b1 | b2 | b3
        i = i+1
        j = j+4

    return hl

def _rotateLeft(x, n): 
    return ((x << n) | (x >> (32-n))) & 0xffffffff

def F(x, y, z):
    return (x & y) | ((~x) & z)

def G(x, y, z):
    return (x & z) | (y & (~z))

def H(x, y, z):
    return x ^ y ^ z

def I(x, y, z):
    return y ^ (x | (~z))


def XX(func, a, b, c, d, x, s, ac):

    res = 0
    res = res + a + func(b, c, d)
    res = res + x 
    res = res + ac
    res = res & 0xffffffff
    res = _rotateLeft(res, s)
    res = res & 0xffffffff
    res = res + b

    return res & 0xffffffff

class MD5:
  
    def __init__(self, md5string=b'', l=0):
               
        self.A = 0
        self.B = 0
        self.C = 0
        self.D = 0
        self.md5str = md5string
        self.origin_length = l
             
        self.length = 0
        self.count = [0, 0]

        self.input = []
        self.HASH_LENGTH = 16
        self.DATA_LENGTH = 64
        if md5string == b'':
            self.init()
        else: 
            self.init2()

    def init(self):
        self.length = 0
        self.input = []

        self.A = 0x67452301
        self.B = 0xefcdab89
        self.C = 0x98badcfe
        self.D = 0x10325476

    def init2(self):
        self.length = 0
        self.input = []
           
        self.A = struct.unpack("I", bytes.fromhex(self.md5str[0:8].decode()))[0]
        self.B = struct.unpack("I", bytes.fromhex(self.md5str[8:16].decode()))[0]
        self.C = struct.unpack("I", bytes.fromhex(self.md5str[16:24].decode()))[0]
        self.D = struct.unpack("I", bytes.fromhex(self.md5str[24:32].decode()))[0]
       
        if self.origin_length == 0:
            self.origin_length = 64

    def _transform(self, inp):

        a, b, c, d = A, B, C, D = self.A, self.B, self.C, self.D
        # Round 1.

        S11, S12, S13, S14 = 7, 12, 17, 22

        a = XX(F, a, b, c, d, inp[ 0], S11, 0xD76AA478) # 1 
        d = XX(F, d, a, b, c, inp[ 1], S12, 0xE8C7B756) # 2 
        c = XX(F, c, d, a, b, inp[ 2], S13, 0x242070DB) # 3 
        b = XX(F, b, c, d, a, inp[ 3], S14, 0xC1BDCEEE) # 4 
        a = XX(F, a, b, c, d, inp[ 4], S11, 0xF57C0FAF) # 5 
        d = XX(F, d, a, b, c, inp[ 5], S12, 0x4787C62A) # 6 
        c = XX(F, c, d, a, b, inp[ 6], S13, 0xA8304613) # 7 
        b = XX(F, b, c, d, a, inp[ 7], S14, 0xFD469501) # 8 
        a = XX(F, a, b, c, d, inp[ 8], S11, 0x698098D8) # 9 
        d = XX(F, d, a, b, c, inp[ 9], S12, 0x8B44F7AF) # 10 
        c = XX(F, c, d, a, b, inp[10], S13, 0xFFFF5BB1) # 11 
        b = XX(F, b, c, d, a, inp[11], S14, 0x895CD7BE) # 12 
        a = XX(F, a, b, c, d, inp[12], S11, 0x6B901122) # 13 
        d = XX(F, d, a, b, c, inp[13], S12, 0xFD987193) # 14 
        c = XX(F, c, d, a, b, inp[14], S13, 0xA679438E) # 15 
        b = XX(F, b, c, d, a, inp[15], S14, 0x49B40821) # 16 

        # Round 2.

        S21, S22, S23, S24 = 5, 9, 14, 20

        a = XX(G, a, b, c, d, inp[ 1], S21, 0xF61E2562) # 17 
        d = XX(G, d, a, b, c, inp[ 6], S22, 0xC040B340) # 18 
        c = XX(G, c, d, a, b, inp[11], S23, 0x265E5A51) # 19 
        b = XX(G, b, c, d, a, inp[ 0], S24, 0xE9B6C7AA) # 20 
        a = XX(G, a, b, c, d, inp[ 5], S21, 0xD62F105D) # 21 
        d = XX(G, d, a, b, c, inp[10], S22, 0x02441453) # 22 
        c = XX(G, c, d, a, b, inp[15], S23, 0xD8A1E681) # 23 
        b = XX(G, b, c, d, a, inp[ 4], S24, 0xE7D3FBC8) # 24 
        a = XX(G, a, b, c, d, inp[ 9], S21, 0x21E1CDE6) # 25 
        d = XX(G, d, a, b, c, inp[14], S22, 0xC33707D6) # 26 
        c = XX(G, c, d, a, b, inp[ 3], S23, 0xF4D50D87) # 27 
        b = XX(G, b, c, d, a, inp[ 8], S24, 0x455A14ED) # 28 
        a = XX(G, a, b, c, d, inp[13], S21, 0xA9E3E905) # 29 
        d = XX(G, d, a, b, c, inp[ 2], S22, 0xFCEFA3F8) # 30 
        c = XX(G, c, d, a, b, inp[ 7], S23, 0x676F02D9) # 31 
        b = XX(G, b, c, d, a, inp[12], S24, 0x8D2A4C8A) # 32 

        # Round 3.

        S31, S32, S33, S34 = 4, 11, 16, 23

        a = XX(H, a, b, c, d, inp[ 5], S31, 0xFFFA3942) # 33 
        d = XX(H, d, a, b, c, inp[ 8], S32, 0x8771F681) # 34 
        c = XX(H, c, d, a, b, inp[11], S33, 0x6D9D6122) # 35 
        b = XX(H, b, c, d, a, inp[14], S34, 0xFDE5380C) # 36 
        a = XX(H, a, b, c, d, inp[ 1], S31, 0xA4BEEA44) # 37 
        d = XX(H, d, a, b, c, inp[ 4], S32, 0x4BDECFA9) # 38 
        c = XX(H, c, d, a, b, inp[ 7], S33, 0xF6BB4B60) # 39 
        b = XX(H, b, c, d, a, inp[10], S34, 0xBEBFBC70) # 40 
        a = XX(H, a, b, c, d, inp[13], S31, 0x289B7EC6) # 41 
        d = XX(H, d, a, b, c, inp[ 0], S32, 0xEAA127FA) # 42 
        c = XX(H, c, d, a, b, inp[ 3], S33, 0xD4EF3085) # 43 
        b = XX(H, b, c, d, a, inp[ 6], S34, 0x04881D05) # 44 
        a = XX(H, a, b, c, d, inp[ 9], S31, 0xD9D4D039) # 45 
        d = XX(H, d, a, b, c, inp[12], S32, 0xE6DB99E5) # 46 
        c = XX(H, c, d, a, b, inp[15], S33, 0x1FA27CF8) # 47 
        b = XX(H, b, c, d, a, inp[ 2], S34, 0xC4AC5665) # 48 

        # Round 4.

        S41, S42, S43, S44 = 6, 10, 15, 21

        a = XX(I, a, b, c, d, inp[ 0], S41, 0xF4292244) # 49 
        d = XX(I, d, a, b, c, inp[ 7], S42, 0x432AFF97) # 50 
        c = XX(I, c, d, a, b, inp[14], S43, 0xAB9423A7) # 51 
        b = XX(I, b, c, d, a, inp[ 5], S44, 0xFC93A039) # 52 
        a = XX(I, a, b, c, d, inp[12], S41, 0x655B59C3) # 53 
        d = XX(I, d, a, b, c, inp[ 3], S42, 0x8F0CCC92) # 54 
        c = XX(I, c, d, a, b, inp[10], S43, 0xFFEFF47D) # 55 
        b = XX(I, b, c, d, a, inp[ 1], S44, 0x85845DD1) # 56 
        a = XX(I, a, b, c, d, inp[ 8], S41, 0x6FA87E4F) # 57 
        d = XX(I, d, a, b, c, inp[15], S42, 0xFE2CE6E0) # 58 
        c = XX(I, c, d, a, b, inp[ 6], S43, 0xA3014314) # 59 
        b = XX(I, b, c, d, a, inp[13], S44, 0x4E0811A1) # 60 
        a = XX(I, a, b, c, d, inp[ 4], S41, 0xF7537E82) # 61 
        d = XX(I, d, a, b, c, inp[11], S42, 0xBD3AF235) # 62 
        c = XX(I, c, d, a, b, inp[ 2], S43, 0x2AD7D2BB) # 63 
        b = XX(I, b, c, d, a, inp[ 9], S44, 0xEB86D391) # 64 

        A = (A + a) & 0xffffffff
        B = (B + b) & 0xffffffff
        C = (C + c) & 0xffffffff
        D = (D + d) & 0xffffffff

        self.A, self.B, self.C, self.D = A, B, C, D

    def update(self, inBuf):
 
        if isinstance(inBuf, str):
            inBuf = inBuf.encode('utf-8')
            
        leninBuf = len(inBuf)
        index = (self.count[0] >> 3) & 0x3F

        self.count[0] = self.count[0] + (leninBuf << 3)
        if self.count[0] < (leninBuf << 3):
            self.count[1] = self.count[1] + 1
        self.count[1] = self.count[1] + (leninBuf >> 29)

        partLen = 64 - index

        if leninBuf >= partLen:
            self.input[index:] = list(inBuf[:partLen])
            self._transform(_bytelist2long(self.input))
            i = partLen
            while i + 63 < leninBuf:
                self._transform(_bytelist2long(list(inBuf[i:i+64])))
                i = i + 64
            else:
                self.input = list(inBuf[i:leninBuf])
        else:
            i = 0
            self.input = self.input + list(inBuf)

    def digest(self):
        A = self.A
        B = self.B
        C = self.C
        D = self.D
        input_copy = self.input.copy()
        count = self.count.copy()

        index = (self.count[0] >> 3) & 0x3f

        if index < 56:
            padLen = 56 - index
        else:
            padLen = 120 - index

        padding = [0x80] + [0] * 63  
        self.update(bytes(padding[:padLen]))
        count[0] += self.origin_length * 8 
        bits = _bytelist2long(self.input[:56]) + count
        self._transform(bits)
        digest = (_long2bytes(self.A << 96, 16)[:4] + 
                  _long2bytes(self.B << 64, 16)[4:8] + 
                  _long2bytes(self.C << 32, 16)[8:12] + 
                  _long2bytes(self.D, 16)[12:])

        self.A = A 
        self.B = B
        self.C = C
        self.D = D
        self.input = input_copy
        self.count = count

        return digest

    def hexdigest(self):
        d = self.digest()
        return ''.join(f'{b:02x}' for b in d)

    def copy(self):
        return copy.deepcopy(self)

def new(arg=None):
    md5 = MD5()
    if arg:
        md5.update(arg)
    return md5

def md5(arg=None):
    return new(arg)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python md5.py [hash] [text]", file=sys.stderr)
        sys.exit(1)

    operation = sys.argv[1].lower()
    text = sys.argv[2]

    if operation == "hash":
        md5 = MD5()
        md5.update(text)
        result = md5.hexdigest()
        print(result)
    else:
        print("Invalid operation. Use 'encode' or 'decode'.", file=sys.stderr)
        sys.exit(1)

