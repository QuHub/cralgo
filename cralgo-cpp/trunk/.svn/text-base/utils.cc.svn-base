short sign(float c){
	if (c >= 0 )
		return 1;
	else return -1;
}


/**********************************
* accepts a decimal integer and returns a binary coded string
* only for unsigned values
 **********************************/

void dec2bin(long decimal, char *binary, int radix)
{
	int k = 0, n = 0;
	int neg_flag = 0;
	int remain;
	int old_decimal; // for test
	char temp[80];
	// take care of negative input

	if (decimal < 0)
	{
		decimal = -decimal;
		neg_flag = 1;
	}
	do
	{
		old_decimal = decimal; // for test
		remain = decimal % 2;
		// whittle down the decimal number
		decimal = decimal / 2;
		// this is a test to show the action
		//printf("%d/2 = %d remainder = %d\n", old_decimal, decimal, remain);
		// converts digit 0 or 1 to character '0' or '1'
		temp[k++] = remain + '0';
	} while (decimal > 0);

//	if (neg_flag)
//		temp[k++] = '-'; // add - sign
//	else
//		temp[k++] = ' '; // space

	// reverse the spelling
	if (k < radix)
		while (n < (radix - k))
			binary[n++] = '0';
	while (k >= 0)
		binary[n++] = temp[--k];

	binary[n-1] = 0; // end with NULL
}

/**********************************
* copy the representation of one gate to another
 **********************************/
void copyRep(char *src, char *dst){
	for (int a = 0; a < REPSIZE; a++){
		dst[a] = src[a];
	}
	dst[REPSIZE] = '\0';
}
/**********************************
* compare the representation of one gate to another
 **********************************/
bool compareRep(char *src, char *dst){
	for (int a = 0; a < REPSIZE; a++){
		if (dst[a] != src[a]) return false;
	}
	return true;
}
/**********************************
* increment the representation with the provided seed
 **********************************/
void initRep(char *dst){
	for (int a = 0; a < REPSIZE; a++){
		dst[a] = char(CHARMIN);
	}
	dst[REPSIZE] = '\0';
}/**********************************
* increment the representation with the provided seed
 **********************************/
void initRep(char *dst, int seed){
	for (int a = 0; a < REPSIZE; a++){
		dst[a] = char(seed);
	}
	dst[REPSIZE] = '\0';
}

/**********************************
* increment the representation within the allowed
* range and skip the 'p' character
 **********************************/
void incRep(char *dest){
	if (dest[0] < CHARMAX){
		dest[0] = char(dest[0]+1);
		if (dest[0] == 'p') dest[0] = char(dest[0]+1);
	} else {
		dest[0] = CHARMIN;
		if (dest[1] < CHARMAX){
			dest[1] = char(dest[1]+1);
			if (dest[1] == 'p') dest[1] = char(dest[1]+1);
		} else {
			dest[1] = CHARMIN;
			if (dest[2] < CHARMAX){
				dest[2] = char(dest[2]+1);
				if (dest[2] == 'p') dest[2] = char(dest[2]+1);
			} else {
				cout<<"Cannot incerement anymore the gate counter, Exiting!!!"<<endl;
			}
		}
	}
	dest[REPSIZE] = '\0';
}
/**********************************
* increment the representation within the allowed
* range and skip the 'p' character parametrized
 **********************************/
void incRep(char *dest, int min, int max){
	if (dest[0] < max){
		dest[0] = char(dest[0]+1);
		if (dest[0] == 'p') dest[0] = char(dest[0]+1);
	} else {
		dest[0] = min;
		if (dest[1] < max){
			dest[1] = char(dest[1]+1);
			if (dest[1] == 'p') dest[1] = char(dest[1]+1);
		} else {
			dest[1] = min;
			if (dest[2] < max){
				dest[2] = char(dest[2]+1);
				if (dest[2] == 'p') dest[2] = char(dest[2]+1);
			} else {
				cout<<"Cannot incerement anymore the gate counter, Exiting!!!"<<endl;
			}
		}
	}
	dest[REPSIZE] = '\0';
}
/**********************************
* return the beginning index of a gate in a genome
 **********************************/
int getGatePos(int pos, string s){
	int end = s.find('p',pos);
	int begin = s.rfind('p',pos)+1;
	int real_pos = pos-begin;
	int pos_div = real_pos/3;
	int pos_mod = real_pos%3;
	return pos-pos_mod;
//	int l = s.length();
//	int index = pos;
//	while (begin != l -1){
//		while (s.at(begin) == 'p'){
//			begin++;
//		}
//		end = begin;
//		while(s.at(end) != 'p'){
//			end++;
//		}
//		if (pos >= begin && pos <= end){
//			index = index - begin; 
//		}
//	}
}

/**********************************
* return the pointer to the gate encoding
 **********************************/
void getGateRepfromStr(int pos, string str, char *representation){
	representation[0] = str.at(pos);
	representation[1] = str.at(pos+1);
	representation[2] = str.at(pos+2);
	representation[REPSIZE] = '\0';
	
}
