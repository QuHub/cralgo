#include "cr.h"

/*
* recursive function that reoders the PLA like input file by looking at the natural order fo the cubes
* arguments: 
*		level - level of the variable hierarchy  where to start the ordering - should be 2 
*		start - 
*
*/
void order_level_tree(int level, int start, int levelcount, int input_counter, int wires, int **inputcubes, int outputwires, int **outputcubes){
	if (level >= wires-1)
		return;
	if (levelcount < 2)
		return;
	int ocount = 0;
	int tocount = 1024;
	int icount = -1;
	int fcounter = 0;
	int icountindex;
	int cube_counter;
	int *inputOcubes[levelcount];
	int *outputOcubes[levelcount];
	int *finputOcubes[levelcount];
	int *foutputOcubes[levelcount];
	for (int y = 0; y < levelcount; y++){
		inputOcubes[y] = new int[wires];
		finputOcubes[y] = new int[wires];
		outputOcubes[y] = new int[outputwires];
		foutputOcubes[y] = new int[outputwires];
	}
	for (int a = start; a < start+levelcount; a++){
		if (tocount > inputcubes[a][level]) tocount = inputcubes[a][level];
	}
	while(ocount < levelcount){
		cube_counter = 0;
		icountindex = 0;
		for (int u = start; u < (start+levelcount); u++){
			if (tocount == inputcubes[u][level]){
				if (icount != tocount) {icount = tocount;}
				for (int v =0; v < wires;v++) inputOcubes[icountindex][v] = inputcubes[u][v];
				for (int v =0; v < outputwires;v++) outputOcubes[icountindex][v] = outputcubes[u][v];
				ocount++;
				icountindex++;
				cube_counter++;
			}
		}
		if (cube_counter > 1) {
			order_level_tree(level+2, 0, cube_counter, input_counter, wires, inputOcubes, outputwires, outputOcubes);
			for (int u = 0; u < cube_counter; u++){
				for (int v =0; v < wires;v++) 
					finputOcubes[fcounter+u][v] = inputOcubes[u][v];
				for (int v =0; v < outputwires;v++) 
					foutputOcubes[fcounter+u][v] = outputOcubes[u][v];
			}
			fcounter += cube_counter;
		} else if (cube_counter == 1){
			for (int u = 0; u < cube_counter; u++){
                                for (int v =0; v < wires;v++)
                                        finputOcubes[fcounter+u][v] = inputOcubes[u][v];
				for (int v =0; v < outputwires;v++) 
					foutputOcubes[fcounter+u][v] = outputOcubes[u][v];
			}
                        fcounter += cube_counter;
		}
		tocount++;
	}
	for (int u = 0;u < levelcount; u++){
		for (int v = 0; v < wires;v++)inputcubes[start+u][v] = finputOcubes[u][v];
		for (int v = 0; v < outputwires;v++)outputcubes[start+u][v] = foutputOcubes[u][v];
	}
	for (int y = 0; y < levelcount; y++){
		delete inputOcubes[y];
		delete finputOcubes[y];
		delete outputOcubes[y];
		delete foutputOcubes[y];
	}

}

/*
* Read the circuit specified in a .pla file into array
*/
int read_pla_file(ifstream& pla_in_stream, int input_counter, int *inout, int **inputcubes, int **outputcubes){
	int in, out, k, icounter;
	string line;
	cout<<input_counter<<" inputs detected"<<endl;
	while(line[0] != '.'){
		getline(pla_in_stream,line);
		cout<< line<<endl;
	}
	icounter = 0;
	while(line[0] != '.' || line[1] != 'e'){
		if(line[0] == '.' && line[1] == 'i' && line[2] == ' '){
			string num = "";
			k = 3;
			while(line[k] != '\0') num += line[k++];
			in = atoi(num.c_str());
			cout <<"in: "<< in<<"  "<<line<<endl;
			inout[0] = in;
			for (int y = 0; y < input_counter; y++){
				inputcubes[y] = new int[inout[0]];
			}

		}
		if(line[0] == '.' && line[1] == 'o' && line[2] == ' '){
			string num = "";
			k = 3;
			while(line[k] != '\0') num += line[k++];
			out = atoi(num.c_str());
			cout <<"out: "<< out<<"  "<<line<<endl;
			inout[1] = out;
			for (int y = 0; y < input_counter; y++){
				outputcubes[y] = new int[inout[1]];
			}
		} else if(line[0] == '0' || line[0] == '1' || line[0]  == '-'){
			for (int l = 0; l < inout[0]; l++){
				if(line[l] == '0' || line[l] == '1')	
					inputcubes[icounter][l] = line[l] - '0';
				else {
					inputcubes[icounter][l] = -1;
				}
			}
			for (int l = 0; l < inout[1]; l++){
                                if(line[l+inout[0]+1] == '0' || line[l+inout[0]+1] == '1')
                                        outputcubes[icounter][l] = line[l+inout[0]+1] - '0';
                        }
			icounter++;
		}
		getline(pla_in_stream,line);
	}
	return 1;
}

int minimize_pla(int input_counter, int *inout, int ***gatearray, int ***cgatearray, char **wirepcarray){
	int top_controls[input_counter*4];
	int down_controls[input_counter*4];
	int count = 0;
	int c = 0;

	for(int u =0; u < (input_counter*2); u=u+2){
		for(int o =1; o < (inout[0]*2); o++){ 
			if (cgatearray[u][o][0] != -1 && cgatearray[u][o][0] != -10){
				if (cgatearray[u][o][0]%2 == 1){
					int cc = u%2 + u/2;
					wirepcarray[cc][cgatearray[u][o][0]] = 'C';
				}
			}
		}
	}


	//determine the topmost non-don't care control bits
	for(int o =0; o < inout[0]*2; o++){ 
		for(int u =0; u < input_counter; u++){
			cout<<wirepcarray[u][o]<<", ";
		}
		cout<<endl;
	}
	cout<<endl;



	cout<<" up: ";
	for(int u =0; u < (input_counter*2); u=u+2){
		for(int o =1; o < (inout[0]*2); o++){ 
			if (cgatearray[u][o][0] != -1 && cgatearray[u][o][0] != -10){
				top_controls[count] = o;
				cout<<top_controls[count++]<<", ";
				break;
			}
		}
	}
	cout<<endl;
	count = 0;
	cout<<" down : ";
	for(int u =0; u < (input_counter*2); u++){
		for(int o = (inout[0]*2)-1; o>=1; o--){ 
			if (gatearray[u][o][0] > -1 && o > 1){
				down_controls[count] = o;
				cout<<down_controls[count++]<<", ";
				break;
			}
		}
	}
	cout<<endl;


	/* transform what can be transformed to CNOT gates using simple rule
	   if two consecutive toffolis are modifying a pair of variables in a sequence
	   replace them by one toffoli and a cnot */
	for(int u =1; u < count; u++){
		for(int v =u-1; v >= 0; v--){
			if (gatearray[v][top_controls[u]][0] != -1 &&( down_controls[u] == top_controls[u] )){
				wirepcarray[u][gatearray[u][top_controls[u]][1]] = '-';
				gatearray[u][top_controls[u]][1] = -1;
				break;
			}
		}
	}

	for(int o =0; o < (inout[0]*2); o++){ 
		for(int u =0; u < input_counter*2; u++){
			if (gatearray[u][o][0] == -1 || o == 1){
				cout<<"{  ,  }";
			} else {
				if (gatearray[u][o][0] >= 10){
					cout<<"{"<<gatearray[u][o][0]<<",";
				} else if (gatearray[u][o][0] < 10){
					cout<<"{ "<<gatearray[u][o][0]<<",";
				}

				if (gatearray[u][o][1] >= 10){
					cout<<gatearray[u][o][1]<<"}";
				}  else if (gatearray[u][o][1] < 10){
					cout<<" "<<gatearray[u][o][1]<<"}";
				}
			}
		}
		cout<<endl;
	}
	cout<<endl;

	for(int o =0; o < inout[0]*2; o++){ 
		for(int u =0; u < input_counter; u++){
			cout<<wirepcarray[u][o]<<", ";
		}
		cout<<endl;
	}
	cout<<endl;

	
	int level = inout[0]*2-1;
	while(true){

		/*determine the bottom- and top-most  non-don't care control bits*/
		count = 0;
		cout<<" up1 : ";
		for(int u =0; u < (input_counter*2); u++){
			for(int o =1; o < (inout[0]*2); o++){ 
				if (gatearray[u][o][0] > -1 && o > 1){
					top_controls[count] = o;
					cout<<top_controls[count++]<<", ";
					break;
				}
			}
		}
		cout<<endl;
		count = 0;
		cout<<" down1 : ";
		for(int u =0; u < (input_counter*2); u++){
			for(int o = (inout[0]*2)-1; o>=1; o--){ 
				if (gatearray[u][o][0] > -1 && o > 1){
					down_controls[count] = o;
					cout<<down_controls[count++]<<", ";
					break;
				}
			}
		}
		cout<<endl;

		/* merge compatible columns under same upper controls*/
		for(int u = 0;u<count-1; u++){
				if ((down_controls[u+1] == down_controls[u]) && (top_controls[u+1] == down_controls[u+1]) && (top_controls[u] < top_controls[u+1])){
					cout<<"controls: "<<u<<" : "<<down_controls[u]<<" -> "<<(u+1)<<" : "<<down_controls[u+1]<<endl;
						wirepcarray[u+1][gatearray[u+1][down_controls[u+1]][0]] = '-';
						wirepcarray[u+1][gatearray[u+1][down_controls[u+1]][1]] = '-';
						wirepcarray[u+1][down_controls[u+1]] = '-';
						wirepcarray[u][gatearray[u][down_controls[u]][1]] = '-';
						wirepcarray[u][gatearray[u][down_controls[u]][0]] = '-';

						gatearray[u+1][down_controls[u+1]][0] = -1;
						gatearray[u][down_controls[u]][1] = -1;
						gatearray[u][down_controls[u]][0] = -1;
				}
		}


	cout<<endl;

	for(int o =0; o < inout[0]*2; o++){ 
		for(int u =0; u < input_counter; u++){
			cout<<wirepcarray[u][o]<<", ";
		}
		cout<<endl;
	}
	cout<<endl;

		/*determine the bottom- and top-most  non-don't care control bits*/
		count = 0;
		cout<<" up1 : ";
		for(int u =0; u < (input_counter*2); u++){
			for(int o =1; o < (inout[0]*2); o++){ 
				if (gatearray[u][o][0] > -1 && o > 1){
					top_controls[count] = o;
					cout<<top_controls[count++]<<", ";
					break;
				}
			}
		}
		cout<<endl;
		count = 0;
		cout<<" down1 : ";
		for(int u =0; u < (input_counter*2); u++){
			for(int o = (inout[0]*2)-1; o>=1; o--){ 
				if (gatearray[u][o][0] > -1 && o > 1){
					down_controls[count] = o;
					cout<<down_controls[count++]<<", ";
					break;
				}
			}
		}
		cout<<endl;

		/* merge compatible columns when being on the highest level*/
/*		for(int u = 0;u<count-1; u++){
				if ((down_controls[u+1] == down_controls[u]) && (top_controls[u+1] == top_controls[u]) && (top_controls[u] == down_controls[u+1])){
					cout<<"controls: "<<u<<" : "<<down_controls[u]<<" -> "<<(u+1)<<" : "<<down_controls[u+1]<<endl;
						wirepcarray[u+1][gatearray[u+1][down_controls[u+1]][0]] = '-';
						wirepcarray[u][gatearray[u][down_controls[u]][1]] = '-';
						wirepcarray[u][gatearray[u][down_controls[u]][0]] = '-';

						gatearray[u+1][down_controls[u+1]][0] = -1;
						gatearray[u+1][down_controls[u+1]][1] = -1;
						gatearray[u][down_controls[u]][1] = -1;
						gatearray[u][down_controls[u]][0] = -1;
				}
		}
*/
		/* move columns together if empty columns are in between */
		int last_i = 0;
		for(int u = 1;u<(input_counter*2); u++){
			bool empty = true;
			for(int o = 0; o<(inout[0]*2); o++){ 
				if (gatearray[u][o][0] != -1 && o != 1){
					empty = false;
					break;
				}
			}
			if (empty) {
					for(int u = 1;u<(input_counter*2); u++){
						empty = true;
						for(int o = 0; o<(inout[0]*2); o++){
							if (gatearray[u][o][0] != -1 && o != 1){
								empty = false;
								break;
							}
						}
						if (empty) {
							last_i = u;
							break;
						}
					}
			} else {
				//move the full column to the previous empty one
				if (last_i > 0){
					for(int o = (inout[0]*2)-1; o>=0; o--){
						wirepcarray[last_i][o] = wirepcarray[u][o];
						wirepcarray[last_i][o] = wirepcarray[u][o];
						wirepcarray[u][o] = '-';
						wirepcarray[u][o] = '-';

						gatearray[last_i][o][0] = gatearray[u][o][0];
						gatearray[last_i][o][1] = gatearray[u][o][1];	
						gatearray[u][o][0] = -1;
						gatearray[u][o][1] = -1;	
					}
				}
			}
		}
		cout<<endl;
		cout<<"merging complete"<<endl;

		
		/*determine the bottom most  non-don't care control bits*/
		count = 0;
		cout<<" up2 : ";
		for(int u =0; u < (input_counter*2); u++){
			for(int o =1; o < (inout[0]*2); o++){ 
				if (gatearray[u][o][0] > -1 && o > 1){
					top_controls[count] = o;
					cout<<top_controls[count++]<<", ";
					break;
				}
			}
		}
		cout<<endl;
		count = 0;
		cout<<" down2 : ";
		for(int u =0; u < (input_counter*2); u++){
			for(int o = (inout[0]*2)-1; o>=1; o--){ 
				if (gatearray[u][o][0] > -1 && o > 1){
					down_controls[count] = o;
					cout<<down_controls[count++]<<", ";
					break;
				}
			}
		}
		cout<<endl;

		
		for(int o =0; o < (inout[0]*2); o++){ 
			for(int u =0; u < input_counter*2; u++){
				if (gatearray[u][o][0] == -1 || o == 1){
					cout<<"{  ,  }";
				} else {
					if (gatearray[u][o][0] >= 10){
						cout<<"{"<<gatearray[u][o][0]<<",";
					} else if (gatearray[u][o][0] < 10){
						cout<<"{ "<<gatearray[u][o][0]<<",";
					}

					if (gatearray[u][o][1] >= 10){
						cout<<gatearray[u][o][1]<<"}";
					}  else if (gatearray[u][o][1] < 10){
						cout<<" "<<gatearray[u][o][1]<<"}";
					}
				}
			}
			cout<<endl;
		}
		cout<<endl;

		for(int o =0; o < inout[0]*2; o++){ 
			for(int u =0; u < input_counter; u++){
				cout<<wirepcarray[u][o]<<", ";
			}
			cout<<endl;
		}
		cout<<endl;


		c++;
		level = level -2;
		if (c>2) break;
	}

	/*determine the bottom most  non-don't care control bits*/
	count = 0;
	cout<<" up2 : ";
	for(int u =0; u < (input_counter*2); u++){
		for(int o =1; o < (inout[0]*2); o++){ 
			if (gatearray[u][o][0] > -1 && o > 1){
				top_controls[count] = o;
				cout<<top_controls[count++]<<", ";
				break;
			}
		}
	}
	cout<<endl;
	count = 0;
	cout<<" down2 : ";
	for(int u =0; u < (input_counter*2); u++){
		for(int o = (inout[0]*2)-1; o>=1; o--){ 
			if (gatearray[u][o][0] > -1 && o > 1){
				down_controls[count] = o;
				cout<<down_controls[count++]<<", ";
				break;
			}
		}
	}
	cout<<endl;
	







	/* transform neighbor top toffolis to CNOT and CNOT*/
	for(int u =0; u < count; u++){
		for(int o = (inout[0]*2)-1; o>=1; o--){ 
			if (down_controls[u] == top_controls[u]&& u > 0){
				
				gatearray[u][ down_controls[u] ][0] = gatearray[u][ down_controls[u] ][1];
				gatearray[u][ down_controls[u] ][1] = -1;
				gatearray[u][ (inout[0]*2)-1][0] = down_controls[u];
				gatearray[u][ (inout[0]*2)-1][1] = -1;
				
				break;
			}
		}
	}
	cout<<endl;



	count = 0;
	for(int u =0; u < (input_counter*2); u++){
		for(int o = (inout[0]*2)-1; o>=1; o--){ 
			if (gatearray[u][o][0] > -1 && o > 1){
				if (o < (inout[0]*2)-1){
					gatearray[u][(inout[0]*2)-1][0] = gatearray[u][o][0];
					gatearray[u][(inout[0]*2)-1][1] = gatearray[u][o][1];
					gatearray[u][o][0] = -1;
					gatearray[u][o][1] = -1;
				}
				break;
			}
		}
	}
	cout<<endl;



	return count;
}
/***************************************
* parameter full 
* full = 0 the pla is a completely specified Multi-input multi-output reversible function
* full = 1 the pla is a single bit - directly realizable reversible function 
* full = 2 dont't cares on the inputs and outputs
* full = 3  multi-input and single output function that requires embedding
****************************************/
int decompose_pla_v(int full, int input_counter, int *inout, int **inputcubes, int **outputcubes, int ***finalgatearray, char **wirePCarray){
	int input_index, output_index, counter, tocount, ocounter, m;
	int level, icountindex, gatecost, ancilla, twobitg, threebitg, dcarecount, gatecostmin;
	int c1, c2, target;
	int cube_counter;
	int *inputOcubes[input_counter*4];
	int *outputOcubes[input_counter*4];
	float gatearray[input_counter*4];
	float controlcounter[input_counter*4];
	short *wirearray[input_counter*4];
	int *wireIarray[input_counter*4];
	char *wireVarray[input_counter*4];
	char *finalarray[input_counter*4];
	int **finalCgatearray[input_counter*4];
	bool different[input_counter*4];
	int top_controls[input_counter*4];
	bool bottom;
	char variables[input_counter*4];
	short ancillas[input_counter*4];
	char r = 'r';

	for (int y = 0; y < input_counter*4; y++){
		inputOcubes[y] = new int[inout[0]];
		for (int x = 0; x < inout[0]; x++)
			inputOcubes[y][x] = 0;
		wirearray[y] = new short[inout[0]];
		wireIarray[y] = new int[inout[0]];
		wireVarray[y] = new char[inout[0]];
		finalarray[y] = new char[inout[0]*2];
		finalCgatearray[y] = new int*[inout[0]*2];
		for (int x = 0; x < (inout[0]*2); x++){
			finalCgatearray[y][x] = new int[4];
			finalCgatearray[y][x][0] = -10;
			finalCgatearray[y][x][1] = -10;
			finalCgatearray[y][x][2] = -10;
			finalCgatearray[y][x][3] = -10;
		}
	}
	for (int y = 0; y < input_counter*4; y++){
		outputOcubes[y] = new int[inout[1]];
		for (int x = 0; x < inout[1]; x++)
			outputOcubes[y][x] = 0;
	}



	/* do a two bit encoding */
	counter = 0;
	while(true){
		for(m = 0; m < input_counter; m++){
			if (inputcubes[m][counter] == 0 && inputcubes[m][counter+1] == 0){
				inputcubes[m][counter] = 2;	
				inputcubes[m][counter+1] = 2;	
			} else if (inputcubes[m][counter] == 0 && inputcubes[m][counter+1] == 1){
				inputcubes[m][counter] = 3;	
				inputcubes[m][counter+1] = 3;	
			} else if (inputcubes[m][counter] == 1 && inputcubes[m][counter+1] == 0){
				inputcubes[m][counter] = 4;	
				inputcubes[m][counter+1] = 4;	
			} else if (inputcubes[m][counter] == 1 && inputcubes[m][counter+1] == 1){
				inputcubes[m][counter] = 5;	
				inputcubes[m][counter+1] = 5;	
			} else if (inputcubes[m][counter] == 0 && inputcubes[m][counter+1] == -1){
				inputcubes[m][counter] = 6;
				inputcubes[m][counter+1] = 6;	
			} else if (inputcubes[m][counter] == 1 && inputcubes[m][counter+1] == -1){
				inputcubes[m][counter] = 7;	
				inputcubes[m][counter+1] = 7;	
                       } else if (inputcubes[m][counter] == -1 && inputcubes[m][counter+1] == 0){
				inputcubes[m][counter] = 8;	
				inputcubes[m][counter+1] = 8;	
                       } else if (inputcubes[m][counter] == -1 && inputcubes[m][counter+1] == 1){
				inputcubes[m][counter] = 9;	
				inputcubes[m][counter+1] = 9;	
                       } else if (inputcubes[m][counter] == -1 && inputcubes[m][counter+1] == -1){
				inputcubes[m][counter] = 10;	
				inputcubes[m][counter+1] = 10;	
                       }
		}
		if (counter < inout[0] - 2)
			counter += 2;
		else
			break;
	}

	/* do a two bit gray encoding */
/*	counter = 0;
	while(true){
		for(m = 0; m < input_counter; m++){
			if (inputcubes[m][counter] == 0 && inputcubes[m][counter+1] == 0){
				inputcubes[m][counter] = 2;	
				inputcubes[m][counter+1] = 2;	
			} else if (inputcubes[m][counter] == 0 && inputcubes[m][counter+1] == 1){
				inputcubes[m][counter] = 3;	
				inputcubes[m][counter+1] = 3;	
			} else if (inputcubes[m][counter] == 1 && inputcubes[m][counter+1] == 1){
				inputcubes[m][counter] = 4;	
				inputcubes[m][counter+1] = 4;	
			} else if (inputcubes[m][counter] == 1 && inputcubes[m][counter+1] == 0){
				inputcubes[m][counter] = 5;	
				inputcubes[m][counter+1] = 5;	
			} else if (inputcubes[m][counter] == 0 && inputcubes[m][counter+1] == -1){
				inputcubes[m][counter] = 6;
				inputcubes[m][counter+1] = 6;	
			} else if (inputcubes[m][counter] == 1 && inputcubes[m][counter+1] == -1){
				inputcubes[m][counter] = 7;	
				inputcubes[m][counter+1] = 7;	
                       } else if (inputcubes[m][counter] == -1 && inputcubes[m][counter+1] == 0){
				inputcubes[m][counter] = 8;	
				inputcubes[m][counter+1] = 8;	
                       } else if (inputcubes[m][counter] == -1 && inputcubes[m][counter+1] == 1){
				inputcubes[m][counter] = 9;	
				inputcubes[m][counter+1] = 9;	
                       } else if (inputcubes[m][counter] == -1 && inputcubes[m][counter+1] == -1){
				inputcubes[m][counter] = 10;	
				inputcubes[m][counter+1] = 10;	
                       }
		}
		if (counter < inout[0] - 2)
			counter += 2;
		else
			break;
	}
*/
	for(int u =0; u < input_counter; u++){
		for(int o =0; o < inout[0]; o++) wirearray[u][o] = -1;
	}



	/* order the circuit by descending order on the input lines */
	counter = -1;	
	ocounter = 0;
	tocount = -1;
	level = 0;
	icountindex = 0;
	while(ocounter < input_counter){
		cube_counter = 0;
		for (int u = 0; u < input_counter; u++){
			if (tocount ==inputcubes[u][level]){
				if (counter != tocount) {counter = tocount;}
				for (int v =0; v < inout[0];v++) inputOcubes[ocounter][v] = inputcubes[u][v];
				if (level == 0)
					for (int v =0; v < inout[1];v++) outputOcubes[ocounter][v] = outputcubes[u][v];
				ocounter++;
				cube_counter++;
			}
		}
		order_level_tree(level+2, icountindex, cube_counter, input_counter, inout[0], inputOcubes, inout[1], outputOcubes);
		icountindex += cube_counter;
		tocount++;

	}



	/* chamge encoding back to positive and negative control points */
	counter = 0;
	while(true){
		for(int m = 0; m < input_counter; m++){
			if (inputOcubes[m][counter] == 2){
				wirearray[m][counter] = 2;	
				wirearray[m][counter+1] = 2;	
			} else if (inputOcubes[m][counter] == 3){
				wirearray[m][counter] = 2;	
				wirearray[m][counter+1] = 1;	
			} else if (inputOcubes[m][counter] == 4){
				wirearray[m][counter] = 1;	
				wirearray[m][counter+1] = 2;	
			} else if (inputOcubes[m][counter] == 5){
				wirearray[m][counter] = 1;	
				wirearray[m][counter+1] = 1;	
			} else if (inputOcubes[m][counter] == 6){
				wirearray[m][counter] = 2;
			} else if (inputOcubes[m][counter] == 7){
				wirearray[m][counter] = 1;	
                       } else if (inputOcubes[m][counter] == 8){
				wirearray[m][counter+1] = 2;	
                       } else if (inputOcubes[m][counter] == 9){
				wirearray[m][counter+1] = 1;	
                       }
		}
		if (counter < inout[0] - 2)
			counter += 2;
		else
			break;
	}
	for(int m = 0; m < input_counter; m++)
		if (inputOcubes[m][inout[0]-1] == 1)
			 wirearray[m][inout[0]-1] = 1;
		else if (inputOcubes[m][inout[0]-1] ==0)
			wirearray[m][inout[0]-1] = 2;

	/* create the array filling the gates containing char values*/
/*	for (counter = 0; counter < inout[0]; counter++){
		tocount = -1;
		for(int m = 0; m < input_counter; m++){
			if (m == 0){
				if (wirearray[m][counter] == 1)
					wireCarray[m][counter] = 'c';
				else if (wirearray[m][counter] == 2)
					wireCarray[m][counter] = 'n';
			} else {
				if (!different[m]){
					if (inputOcubes[m][counter] != inputOcubes[m-1][counter]){
						different[m] = true;
						if (wirearray[m][counter] == 1)
							wireCarray[m][counter] = 'c';
						else if (wirearray[m][counter] == 2)
							wireCarray[m][counter] = 'n';
					} else {
						if (m > 0 && wirearray[m-1][counter] != -1)
							wireCarray[m][counter] = '-';
					}
				} else {
					if (wirearray[m][counter] == 1)
							wireCarray[m][counter] = 'c';
						else if (wirearray[m][counter] == 2)
							wireCarray[m][counter] = 'n';
				}
			}
		}
	}

*/	
	/* remove don't cares/ minimize table */
/*	for(int m = 0; m < inout[0]; m++) variables[m] = wireCarray[0][m];
	for(int m = 1; m < input_counter; m++){
		different[0] = false;
		for (counter = 0; counter < inout[0]; counter++){
			if (!different[0]){
				if (wireCarray[m][counter] != variables[counter] && wireCarray[m][counter] != '-'){
					different[0] = true;
					variables[counter] = wireCarray[m][counter];
				} else if (wireCarray[m][counter] == variables[counter] && (variables[counter] == 'n' || variables[counter] == 'c')) wireCarray[m][counter] = '-';
			} else variables[counter] = wireCarray[m][counter];
		}
		

	}
	for (counter = 0; counter < inout[0]; counter++)
		if ((wireCarray[0][counter] == 'n' || wireCarray[0][counter] == 'c')) variables[counter] = wireCarray[0][counter];
	for(int m = 1; m < input_counter; m++){
		int u = 0;
		for (counter = 0; counter < inout[0]; counter++)
			if ((wireCarray[m][counter] == 'n' || wireCarray[m][counter] == 'c')) variables[counter] = wireCarray[m][counter];
		for (counter = 0; counter < inout[0]; counter++){
			if ((wireCarray[m][counter] == 'n' || wireCarray[m][counter] == 'c')) break;
			else if (wireCarray[m][counter] == '-') u++;
		}
		if (u < 2)
		for (counter = 0; counter < inout[0]; counter++){
			if (wireCarray[m][counter] == '-') wireCarray[m][counter] = variables[counter];
		}
	

	}
*/
	/* Copy wireCarray to wirePCarray - having all ancila bits */
/*	for(int o =0; o < inout[0]; o++){ 
		for(int u =0; u < input_counter; u++)
			wirePCarray[u][o*2] = wireCarray[u][o];
		for(int u =0; u < input_counter; u++)
			wirePCarray[u][o*2+1] = '-';
	}
*/
	/* Copy the resulting circuit to a final data structure by skipping don't cares*/
/*	for(int u =0; u < input_counter; u++){
		c1 = -1;
		c2 = -1;
		target = -1;
		counter = 0;
		for(int o =0; o < inout[0]; o++){ 
			if (wireCarray[u][o] == 'c' || wireCarray[u][o] == 'n' ){
				if (counter > 0 && c1 < 0){
					c1 = (counter-1)*2+1;
					c2 = o*2;
					target = o*2+1;
					finalgatearray[u][target][0]= c1;
					finalgatearray[u][target][1]= c2;
					counter = -1;
					c2 = -1;
					c1 = target;
				} else if (c1 < 0) {
					c1 = o*2;
				} else if (c2 < 0){
				       	c2 = o*2;
					target = o*2+1;
					finalgatearray[u][target][0]= c1;
					finalgatearray[u][target][1]= c2;
					c2 = -1;
					c1 = target;
				}

			} else if(wireCarray[u][o] == '-') counter++;
		}
		if (c2 == -1 && c1 != -1 && target < 0){
			finalgatearray[u][inout[0]*2-1][0] = c1;
			finalgatearray[u][inout[0]*2-1][1] = 0;
		}
	}
*/
	for(int u =0; u < input_counter; u++){
		for(int o = (inout[0]*2-1); o >= 0; o--){ 
			if (o == (inout[0]*2-1) && finalgatearray[u][o][0] >= 0) break;

			if ( o < (inout[0]*2-1) && finalgatearray[u][o][0] >= 0){
				finalgatearray[u][inout[0]*2-1][0] = finalgatearray[u][o][0];
				finalgatearray[u][inout[0]*2-1][1] = finalgatearray[u][o][1];
				finalgatearray[u][o][0] = -1;
				finalgatearray[u][o][1] = -1;
				break;
			}
		}
	}
/*	for(int o = (inout[0]*2-1); o >= 0; o--){ 
		if (finalgatearray[0][o][0] != -1){
			finalCgatearray[0][o][0] = finalgatearray[0][o][0];

			if (finalgatearray[0][o][0]%2 != 0)finalCgatearray[0][o][1] = -1 ;
		      	else 	(wireCarray[0][finalgatearray[0][o][0]/2] == 'c') ? finalCgatearray[0][o][1] = -1 : finalCgatearray[0][o][1] = -2 ;

			finalCgatearray[0][o][2] = finalgatearray[0][o][1];

			if (finalgatearray[0][o][1]%2 != 0)finalCgatearray[0][o][3] = -1 ;
		      	else 	(wireCarray[0][finalgatearray[0][o][1]/2] == 'c') ? finalCgatearray[0][o][3] = -1 : finalCgatearray[0][o][3] = -2 ;

		}
	}
*/
	/*determine which gates have to be repeated*/
	int u = 0;
	int j = 0;
	char ch1, ch2;
/*	while(true){
		for (int k = 0; k < input_counter; k++)
			finalgatearray[k][1][0] = 0;
		for(int o = 0; (o < inout[0]*2); o++){
			if (o != 1){
				if (finalCgatearray[u][o][1] == -1) ch1 = 'c';
				else if (finalCgatearray[u][o][1] == -2) ch1 = 'n';

				if (finalCgatearray[u][o][3] == -1) ch2 = 'c';
				else if (finalCgatearray[u][o][3] == -2) ch2 = 'n';
				if (ch1 > -10 && ch2 > -10){
					for(int v = (u/2+1); v < input_counter; v++){
						if (finalCgatearray[u][o][0] >= 0 && finalgatearray[v][o][0] != -1){
							if (finalCgatearray[u][o][0] == finalgatearray[v][o][0] && finalCgatearray[u][o][2] == finalgatearray[v][o][1] ){
								if (wireCarray[v][finalgatearray[v][o][0]/2] != ch1 || wireCarray[v][finalgatearray[v][o][1]/2] != ch2 || finalgatearray[v][1][0] == 1){
									finalCgatearray[u+1][o][0] = finalCgatearray[u][o][0];
									finalCgatearray[u+1][o][1] = finalCgatearray[u][o][1];
									finalCgatearray[u+1][o][2] = finalCgatearray[u][o][2];
									finalCgatearray[u+1][o][3] = finalCgatearray[u][o][3];
									finalgatearray[v][1][0] = 1;
									break;
								} 
							}
						}
					}
				}
			}
		}
		u += 2;
		if (u >= (input_counter*2)) break;
		for(int o = (inout[0]*2-1); o >= 0; o--){ 
			if (o != 1){
			finalCgatearray[u][o][0] = finalgatearray[u/2][o][0];

			if (finalgatearray[0][o][0]%2 != 0)finalCgatearray[0][o][1] = -1 ;
		      	else 	(wireCarray[u][finalgatearray[0][o][0]/2] == 'c') ? finalCgatearray[u][o][1] = -1 : finalCgatearray[u][o][1] = -2 ;

			finalCgatearray[u][o][2] = finalgatearray[u/2][o][1];

			if (finalgatearray[u/2][o][1]%2 != 0)finalCgatearray[u][o][3] = -1 ;
		      	else 	(wireCarray[u][finalgatearray[u/2][o][1]/2] == 'c') ? finalCgatearray[u][o][3] = -1 : finalCgatearray[u][o][3] = -2 ;
			}
		}
	}
*/

	/*print the encoded cubesa*/
	for(int o =0; o < inout[0]; o++){ 
		for(int u =0; u < input_counter; u++){
			cout<<inputOcubes[u][o]<<", ";
		}
		cout<<endl;
	}
	for(int u =0; u < input_counter; u++)cout<<"....";
	cout<<endl;
	for(int o =0; o < inout[1]; o++){
		for(int u =0; u < input_counter; u++){
			 cout<<outputOcubes[u][o]<<", ";
		}
		cout<<endl;
	}
	cout<<endl;

	/*print the minimized circuit*/
	for(int o =0; o < (inout[0]*2); o++){ 
		for(int u =0; u < input_counter; u++){
			if (finalgatearray[u][o][0] == -1 || o == 1){
				cout<<"{  ,  }";
			} else {
				if (finalgatearray[u][o][0] >= 10){
					cout<<"{"<<finalgatearray[u][o][0]<<",";
				} else if (finalgatearray[u][o][0] < 10){
					cout<<"{ "<<finalgatearray[u][o][0]<<",";
				}

				if (finalgatearray[u][o][1] >= 10){
					cout<<finalgatearray[u][o][1]<<"}";
				}  else if (finalgatearray[u][o][1] < 10){
					cout<<" "<<finalgatearray[u][o][1]<<"}";
				}
			}
		}
		cout<<endl;
	}


	int count = minimize_pla(input_counter, inout, finalgatearray, finalCgatearray, wirePCarray);

	/*print the minimized circuit*/
	for(int o =0; o < (inout[0]*2); o++){ 
		for(int u =0; u < input_counter*2; u++){
			if (finalgatearray[u][o][0] == -1 || o == 1){
				cout<<"{  ,  }";
			} else {
				if (finalgatearray[u][o][0] >= 10){
					cout<<"{"<<finalgatearray[u][o][0]<<",";
				} else if (finalgatearray[u][o][0] < 10){
					cout<<"{ "<<finalgatearray[u][o][0]<<",";
				}

				if (finalgatearray[u][o][1] >= 10){
					cout<<finalgatearray[u][o][1]<<"}";
				}  else if (finalgatearray[u][o][1] < 10){
					cout<<" "<<finalgatearray[u][o][1]<<"}";
				}
			}
		}
		cout<<endl;
	}
		cout<<endl;

	//function representation output
	for(int o =0; o < inout[0]*2; o++){ 
		for(int u =0; u < input_counter; u++){
			cout<<wirePCarray[u][o]<<", ";
		}
		cout<<endl;
	}
/*
	for(int u =0; u < input_counter; u++)cout<<"....";
	cout<<endl;
	for(int o =0; o < inout[1]; o++){
		for(int u =0; u < input_counter; u++){
			 cout<<outputOcubes[u][o]<<", ";
		}
		cout<<endl;
	}
	cout<<endl;

*/

/*
	for(int o =0; o < (inout[0]*2); o++){ 
		for(int u =0; u < (input_counter*2); u++){
			if (finalgatearray[u][o][0] == -1 || o == 1){
				cout<<"{  ,  }";
			} else {
				if (finalgatearray[u][o][0] >= 10){
					cout<<"{"<<finalgatearray[u][o][0]<<",";
				} else if (finalgatearray[u][o][0] < 10){
					cout<<"{ "<<finalgatearray[u][o][0]<<",";
				}

				if (finalgatearray[u][o][1] >= 10){
					cout<<finalgatearray[u][o][1]<<"}";
				}  else if (finalgatearray[u][o][1] < 10){
					cout<<" "<<finalgatearray[u][o][1]<<"}";
				}
			}
		}
		cout<<endl;
	}
	
		cout<<endl;
		cout<<endl;
*/

	for(int o =0; o < (inout[0]*2); o++){ 
		for(int u =0; u < (input_counter*2); u++){
			if (finalCgatearray[u][o][0] == -10 || finalCgatearray[u][o][0] == -1 || o == 1){
				cout<<"{  ,  }";
			} else {
				if (finalCgatearray[u][o][0] >= 10){
					cout<<"{"<<finalCgatearray[u][o][0]<<",";
				} else if (finalCgatearray[u][o][0] < 10){
					cout<<"{ "<<finalCgatearray[u][o][0]<<",";
				}
				if (finalCgatearray[u][o][2] >= 10){
					cout<<finalCgatearray[u][o][2]<<"}";
				}  else if (finalCgatearray[u][o][2] < 10){
					cout<<" "<<finalCgatearray[u][o][2]<<"}";
				}
			}
		}
		cout<<endl;
	}
		cout<<endl;

	//count number of toffolis from finalCgatearray
	gatecost = 0;
	twobitg = 0;
	threebitg = 0;
	for(int u =0; u < (input_counter*2); u++){
		counter = 0;
		for(int o =0; o < (inout[0]*2); o++){ 
			if (finalgatearray[u][o][0] >-1 && o > 1){
				counter++;
				if (finalgatearray[u][o][1] == -1){
					cout<<"{"<<finalgatearray[u][o][0]<<","<<finalgatearray[u][o][1]<<"}";
					twobitg++;
					gatecost += 1;
				} else {
					cout<<"{"<<finalgatearray[u][o][0]<<","<<finalgatearray[u][o][1]<<"}";
					threebitg++;
					gatecost += 5;
				}
			}
		}
	}
/*
	for(int u =2; u < (input_counter*2); u=u+2)
		if(finalCgatearray[u-2][top_controls[u-2]][0] == finalCgatearray[u][top_controls[u]][0] && finalCgatearray[u-2][top_controls[u-2]][2] == finalCgatearray[u][top_controls[u]][2]){
			gatecost = gatecost -10;
			gatecost = gatecost + 1;
			threebitg = threebitg - 2;
			twobitg = twobitg + 1;

		}
*/
	cout<<" Total cost of the circuit (after minimization) is: "<<gatecost<<endl;
	cout<<" Total number of two bit function gates is: "<<(twobitg)<<endl;
	cout<<" Total number of three bit gates is: "<<(threebitg)<<endl;

	for (int y = 0; y < input_counter*4; y++){
		delete inputOcubes[y];
		delete wirearray[y];
		delete wireIarray[y];
//		delete wireCarray[y];
		delete finalarray[y];
//		delete wireSarray[y];
		for (int x = 0; x < (inout[0]*2); x++){
			delete finalgatearray[y][x];
			delete finalCgatearray[y][x];
		}
		delete finalgatearray[y];
		delete finalCgatearray[y];
	}



	return gatecostmin;
}
/***************************************
* parameter full 
* full = 0 the pla is a completely specified Multi-input multi-output reversible function
* full = 1 the pla is a single bit - directly realizable reversible function 
* full = 2 dont't cares on the inputs and outputs
* full = 3  multi-input and single output function that requires embedding
****************************************/
int process_pla(int full, int input_counter, int *inout, int **inputcubes, int **outputcubes, int *result){
	int input_index, output_index, counter, tocount, ocounter, m;
	int level, icountindex, gatecost, ancilla, twobitg, threebitg, dcarecount, gatecostmin;
	int c1, c2, target;
	int cube_counter;
	int *inputOcubes[input_counter*4];
	int *outputOcubes[input_counter*4];
	float gatearray[input_counter*4];
	float controlcounter[input_counter*4];
	short *wirearray[input_counter*4];
	int *wireIarray[input_counter*4];
	char *wireCarray[input_counter*4];
	char *wirePCarray[input_counter*4];
	char **finalwirePCarray[input_counter*4];
	char *finalarray[input_counter*4];
	int **finalgatearray[input_counter*4];
	int **finalCgatearray[input_counter*4];
//	string *wireSarray[input_counter*4];
	bool different[input_counter*4];
	int top_controls[input_counter*4];
	bool bottom;
	char variables[input_counter*4];
	short ancillas[input_counter*4];
	char r = 'r';

	for (int y = 0; y < input_counter*4; y++){
		inputOcubes[y] = new int[inout[0]];
		for (int x = 0; x < inout[0]; x++)
			inputOcubes[y][x] = 0;
		wirearray[y] = new short[inout[0]];
		wireIarray[y] = new int[inout[0]];
		wireCarray[y] = new char[inout[0]];
		wirePCarray[y] = new char[inout[0]*2];
		finalarray[y] = new char[inout[0]*2];
//		wireSarray[y] = new string[inout[0]];
		finalgatearray[y] = new int*[inout[0]*2];
		finalCgatearray[y] = new int*[inout[0]*2];
		for (int x = 0; x < (inout[0]*2); x++){
			finalgatearray[y][x] = new int[2];
			finalgatearray[y][x][0] = -1;
			finalgatearray[y][x][1] = -1;
			finalCgatearray[y][x] = new int[4];
			finalCgatearray[y][x][0] = -10;
			finalCgatearray[y][x][1] = -10;
			finalCgatearray[y][x][2] = -10;
			finalCgatearray[y][x][3] = -10;
		}
	}
	for (int y = 0; y < input_counter*4; y++){
		outputOcubes[y] = new int[inout[1]];
		for (int x = 0; x < inout[1]; x++)
			outputOcubes[y][x] = 0;
	}



	/* do a two bit encoding */
	counter = 0;
	while(true){
		for(m = 0; m < input_counter; m++){
			if (inputcubes[m][counter] == 0 && inputcubes[m][counter+1] == 0){
				inputcubes[m][counter] = 2;	
				inputcubes[m][counter+1] = 2;	
			} else if (inputcubes[m][counter] == 0 && inputcubes[m][counter+1] == 1){
				inputcubes[m][counter] = 3;	
				inputcubes[m][counter+1] = 3;	
			} else if (inputcubes[m][counter] == 1 && inputcubes[m][counter+1] == 0){
				inputcubes[m][counter] = 4;	
				inputcubes[m][counter+1] = 4;	
			} else if (inputcubes[m][counter] == 1 && inputcubes[m][counter+1] == 1){
				inputcubes[m][counter] = 5;	
				inputcubes[m][counter+1] = 5;	
			} else if (inputcubes[m][counter] == 0 && inputcubes[m][counter+1] == -1){
				inputcubes[m][counter] = 6;
				inputcubes[m][counter+1] = 6;	
			} else if (inputcubes[m][counter] == 1 && inputcubes[m][counter+1] == -1){
				inputcubes[m][counter] = 7;	
				inputcubes[m][counter+1] = 7;	
                       } else if (inputcubes[m][counter] == -1 && inputcubes[m][counter+1] == 0){
				inputcubes[m][counter] = 8;	
				inputcubes[m][counter+1] = 8;	
                       } else if (inputcubes[m][counter] == -1 && inputcubes[m][counter+1] == 1){
				inputcubes[m][counter] = 9;	
				inputcubes[m][counter+1] = 9;	
                       } else if (inputcubes[m][counter] == -1 && inputcubes[m][counter+1] == -1){
				inputcubes[m][counter] = 10;	
				inputcubes[m][counter+1] = 10;	
                       }
		}
		if (counter < inout[0] - 2)
			counter += 2;
		else
			break;
	}

	/* do a two bit gray encoding */
/*	counter = 0;
	while(true){
		for(m = 0; m < input_counter; m++){
			if (inputcubes[m][counter] == 0 && inputcubes[m][counter+1] == 0){
				inputcubes[m][counter] = 2;	
				inputcubes[m][counter+1] = 2;	
			} else if (inputcubes[m][counter] == 0 && inputcubes[m][counter+1] == 1){
				inputcubes[m][counter] = 3;	
				inputcubes[m][counter+1] = 3;	
			} else if (inputcubes[m][counter] == 1 && inputcubes[m][counter+1] == 1){
				inputcubes[m][counter] = 4;	
				inputcubes[m][counter+1] = 4;	
			} else if (inputcubes[m][counter] == 1 && inputcubes[m][counter+1] == 0){
				inputcubes[m][counter] = 5;	
				inputcubes[m][counter+1] = 5;	
			} else if (inputcubes[m][counter] == 0 && inputcubes[m][counter+1] == -1){
				inputcubes[m][counter] = 6;
				inputcubes[m][counter+1] = 6;	
			} else if (inputcubes[m][counter] == 1 && inputcubes[m][counter+1] == -1){
				inputcubes[m][counter] = 7;	
				inputcubes[m][counter+1] = 7;	
                       } else if (inputcubes[m][counter] == -1 && inputcubes[m][counter+1] == 0){
				inputcubes[m][counter] = 8;	
				inputcubes[m][counter+1] = 8;	
                       } else if (inputcubes[m][counter] == -1 && inputcubes[m][counter+1] == 1){
				inputcubes[m][counter] = 9;	
				inputcubes[m][counter+1] = 9;	
                       } else if (inputcubes[m][counter] == -1 && inputcubes[m][counter+1] == -1){
				inputcubes[m][counter] = 10;	
				inputcubes[m][counter+1] = 10;	
                       }
		}
		if (counter < inout[0] - 2)
			counter += 2;
		else
			break;
	}
*/
	for(int u =0; u < input_counter; u++){
		for(int o =0; o < inout[0]; o++) wirearray[u][o] = -1;
	}



	/* order the circuit by descending order on the input lines */
	counter = -1;	
	ocounter = 0;
	tocount = -1;
	level = 0;
	icountindex = 0;
	while(ocounter < input_counter){
		cube_counter = 0;
		for (int u = 0; u < input_counter; u++){
			if (tocount ==inputcubes[u][level]){
				if (counter != tocount) {counter = tocount;}
				for (int v =0; v < inout[0];v++) inputOcubes[ocounter][v] = inputcubes[u][v];
				if (level == 0)
					for (int v =0; v < inout[1];v++) outputOcubes[ocounter][v] = outputcubes[u][v];
				ocounter++;
				cube_counter++;
			}
		}
		order_level_tree(level+2, icountindex, cube_counter, input_counter, inout[0], inputOcubes, inout[1], outputOcubes);
		icountindex += cube_counter;
		tocount++;

	}



	/* chamge encoding back to positive and negative control points */
	counter = 0;
	while(true){
		for(int m = 0; m < input_counter; m++){
			if (inputOcubes[m][counter] == 2){
				wirearray[m][counter] = 2;	
				wirearray[m][counter+1] = 2;	
			} else if (inputOcubes[m][counter] == 3){
				wirearray[m][counter] = 2;	
				wirearray[m][counter+1] = 1;	
			} else if (inputOcubes[m][counter] == 4){
				wirearray[m][counter] = 1;	
				wirearray[m][counter+1] = 2;	
			} else if (inputOcubes[m][counter] == 5){
				wirearray[m][counter] = 1;	
				wirearray[m][counter+1] = 1;	
			} else if (inputOcubes[m][counter] == 6){
				wirearray[m][counter] = 2;
			} else if (inputOcubes[m][counter] == 7){
				wirearray[m][counter] = 1;	
                       } else if (inputOcubes[m][counter] == 8){
				wirearray[m][counter+1] = 2;	
                       } else if (inputOcubes[m][counter] == 9){
				wirearray[m][counter+1] = 1;	
                       }
		}
		if (counter < inout[0] - 2)
			counter += 2;
		else
			break;
	}
	for(int m = 0; m < input_counter; m++)
		if (inputOcubes[m][inout[0]-1] == 1)
			 wirearray[m][inout[0]-1] = 1;
		else if (inputOcubes[m][inout[0]-1] ==0)
			wirearray[m][inout[0]-1] = 2;

	/* create the array filling the gates containing char values*/
	for (counter = 0; counter < inout[0]; counter++){
		tocount = -1;
		for(int m = 0; m < input_counter; m++){
			if (m == 0){
				if (wirearray[m][counter] == 1)
					wireCarray[m][counter] = 'c';
				else if (wirearray[m][counter] == 2)
					wireCarray[m][counter] = 'n';
			} else {
				if (!different[m]){
					if (inputOcubes[m][counter] != inputOcubes[m-1][counter]){
						different[m] = true;
						if (wirearray[m][counter] == 1)
							wireCarray[m][counter] = 'c';
						else if (wirearray[m][counter] == 2)
							wireCarray[m][counter] = 'n';
					} else {
						if (m > 0 && wirearray[m-1][counter] != -1)
							wireCarray[m][counter] = '-';
					}
				} else {
					if (wirearray[m][counter] == 1)
							wireCarray[m][counter] = 'c';
						else if (wirearray[m][counter] == 2)
							wireCarray[m][counter] = 'n';
				}
			}
		}
	}

	
	/* remove don't cares/ minimize table */
	for(int m = 0; m < inout[0]; m++) variables[m] = wireCarray[0][m];
	for(int m = 1; m < input_counter; m++){
		different[0] = false;
		for (counter = 0; counter < inout[0]; counter++){
			if (!different[0]){
				if (wireCarray[m][counter] != variables[counter] && wireCarray[m][counter] != '-'){
					different[0] = true;
					variables[counter] = wireCarray[m][counter];
				} else if (wireCarray[m][counter] == variables[counter] && (variables[counter] == 'n' || variables[counter] == 'c')) wireCarray[m][counter] = '-';
			} else variables[counter] = wireCarray[m][counter];
		}
		

	}
	for (counter = 0; counter < inout[0]; counter++)
		if ((wireCarray[0][counter] == 'n' || wireCarray[0][counter] == 'c')) variables[counter] = wireCarray[0][counter];
	for(int m = 1; m < input_counter; m++){
		int u = 0;
		for (counter = 0; counter < inout[0]; counter++)
			if ((wireCarray[m][counter] == 'n' || wireCarray[m][counter] == 'c')) variables[counter] = wireCarray[m][counter];
		for (counter = 0; counter < inout[0]; counter++){
			if ((wireCarray[m][counter] == 'n' || wireCarray[m][counter] == 'c')) break;
			else if (wireCarray[m][counter] == '-') u++;
		}
		if (u < 2)
		for (counter = 0; counter < inout[0]; counter++){
			if (wireCarray[m][counter] == '-') wireCarray[m][counter] = variables[counter];
		}
	

	}
	/* Copy wireCarray to wirePCarray - having all ancila bits */
	for(int o =0; o < inout[0]; o++){ 
		for(int u =0; u < input_counter; u++)
			wirePCarray[u][o*2] = wireCarray[u][o];
		for(int u =0; u < input_counter; u++)
			wirePCarray[u][o*2+1] = '-';
	}

	/* Copy the resulting circuit to a final data structure by skipping don't cares*/
	for(int u =0; u < input_counter; u++){
		c1 = -1;
		c2 = -1;
		target = -1;
		counter = 0;
		for(int o =0; o < inout[0]; o++){ 
			if (wireCarray[u][o] == 'c' || wireCarray[u][o] == 'n' ){
				if (counter > 0 && c1 < 0){
					c1 = (counter-1)*2+1;
					c2 = o*2;
					target = o*2+1;
					finalgatearray[u][target][0]= c1;
					finalgatearray[u][target][1]= c2;
					counter = -1;
					c2 = -1;
					c1 = target;
				} else if (c1 < 0) {
					c1 = o*2;
				} else if (c2 < 0){
				       	c2 = o*2;
					target = o*2+1;
					finalgatearray[u][target][0]= c1;
					finalgatearray[u][target][1]= c2;
					c2 = -1;
					c1 = target;
				}

			} else if(wireCarray[u][o] == '-') counter++;
		}
		if (c2 == -1 && c1 != -1 && target < 0){
			finalgatearray[u][inout[0]*2-1][0] = c1;
			finalgatearray[u][inout[0]*2-1][1] = 0;
		}
	}

	for(int u =0; u < input_counter; u++){
		for(int o = (inout[0]*2-1); o >= 0; o--){ 
			if (o == (inout[0]*2-1) && finalgatearray[u][o][0] >= 0) break;

			if ( o < (inout[0]*2-1) && finalgatearray[u][o][0] >= 0){
				finalgatearray[u][inout[0]*2-1][0] = finalgatearray[u][o][0];
				finalgatearray[u][inout[0]*2-1][1] = finalgatearray[u][o][1];
				finalgatearray[u][o][0] = -1;
				finalgatearray[u][o][1] = -1;
				break;
			}
		}
	}
	for(int o = (inout[0]*2-1); o >= 0; o--){ 
		if (finalgatearray[0][o][0] != -1){
			finalCgatearray[0][o][0] = finalgatearray[0][o][0];

			if (finalgatearray[0][o][0]%2 != 0)finalCgatearray[0][o][1] = -1 ;
		      	else 	(wireCarray[0][finalgatearray[0][o][0]/2] == 'c') ? finalCgatearray[0][o][1] = -1 : finalCgatearray[0][o][1] = -2 ;

			finalCgatearray[0][o][2] = finalgatearray[0][o][1];

			if (finalgatearray[0][o][1]%2 != 0)finalCgatearray[0][o][3] = -1 ;
		      	else 	(wireCarray[0][finalgatearray[0][o][1]/2] == 'c') ? finalCgatearray[0][o][3] = -1 : finalCgatearray[0][o][3] = -2 ;

		}
	}

	/*determine which gates have to be repeated*/
	int u = 0;
	int j = 0;
	char ch1, ch2;
	while(true){
		for (int k = 0; k < input_counter; k++)
			finalgatearray[k][1][0] = 0;
		for(int o = 0; (o < inout[0]*2); o++){
			if (o != 1){
				if (finalCgatearray[u][o][1] == -1) ch1 = 'c';
				else if (finalCgatearray[u][o][1] == -2) ch1 = 'n';

				if (finalCgatearray[u][o][3] == -1) ch2 = 'c';
				else if (finalCgatearray[u][o][3] == -2) ch2 = 'n';
				if (ch1 > -10 && ch2 > -10){
					for(int v = (u/2+1); v < input_counter; v++){
						if (finalCgatearray[u][o][0] >= 0 && finalgatearray[v][o][0] != -1){
							if (finalCgatearray[u][o][0] == finalgatearray[v][o][0] && finalCgatearray[u][o][2] == finalgatearray[v][o][1] ){
								if (wireCarray[v][finalgatearray[v][o][0]/2] != ch1 || wireCarray[v][finalgatearray[v][o][1]/2] != ch2 || finalgatearray[v][1][0] == 1){
									finalCgatearray[u+1][o][0] = finalCgatearray[u][o][0];
									finalCgatearray[u+1][o][1] = finalCgatearray[u][o][1];
									finalCgatearray[u+1][o][2] = finalCgatearray[u][o][2];
									finalCgatearray[u+1][o][3] = finalCgatearray[u][o][3];
									finalgatearray[v][1][0] = 1;
									break;
								} 
							}
						}
					}
				}
			}
		}
		u += 2;
		if (u >= (input_counter*2)) break;
		for(int o = (inout[0]*2-1); o >= 0; o--){ 
			if (o != 1){
			finalCgatearray[u][o][0] = finalgatearray[u/2][o][0];

			if (finalgatearray[0][o][0]%2 != 0)finalCgatearray[0][o][1] = -1 ;
		      	else 	(wireCarray[u][finalgatearray[0][o][0]/2] == 'c') ? finalCgatearray[u][o][1] = -1 : finalCgatearray[u][o][1] = -2 ;

			finalCgatearray[u][o][2] = finalgatearray[u/2][o][1];

			if (finalgatearray[u/2][o][1]%2 != 0)finalCgatearray[u][o][3] = -1 ;
		      	else 	(wireCarray[u][finalgatearray[u/2][o][1]/2] == 'c') ? finalCgatearray[u][o][3] = -1 : finalCgatearray[u][o][3] = -2 ;
			}
		}
	}

	/*print the encoded cubesa*/
	for(int o =0; o < inout[0]; o++){ 
		for(int u =0; u < input_counter; u++){
			cout<<inputOcubes[u][o]<<", ";
		}
		cout<<endl;
	}
	for(int u =0; u < input_counter; u++)cout<<"....";
	cout<<endl;
	for(int o =0; o < inout[1]; o++){
		for(int u =0; u < input_counter; u++){
			 cout<<outputOcubes[u][o]<<", ";
		}
		cout<<endl;
	}
	cout<<endl;

	/*print the minimized circuit*/
	for(int o =0; o < (inout[0]*2); o++){ 
		for(int u =0; u < input_counter; u++){
			if (finalgatearray[u][o][0] == -1 || o == 1){
				cout<<"{  ,  }";
			} else {
				if (finalgatearray[u][o][0] >= 10){
					cout<<"{"<<finalgatearray[u][o][0]<<",";
				} else if (finalgatearray[u][o][0] < 10){
					cout<<"{ "<<finalgatearray[u][o][0]<<",";
				}

				if (finalgatearray[u][o][1] >= 10){
					cout<<finalgatearray[u][o][1]<<"}";
				}  else if (finalgatearray[u][o][1] < 10){
					cout<<" "<<finalgatearray[u][o][1]<<"}";
				}
			}
		}
		cout<<endl;
	}


	int count = minimize_pla(input_counter, inout, finalgatearray, finalCgatearray, wirePCarray);

	/*print the minimized circuit*/
	for(int o =0; o < (inout[0]*2); o++){ 
		for(int u =0; u < input_counter*2; u++){
			if (finalgatearray[u][o][0] == -1 || o == 1){
				cout<<"{  ,  }";
			} else {
				if (finalgatearray[u][o][0] >= 10){
					cout<<"{"<<finalgatearray[u][o][0]<<",";
				} else if (finalgatearray[u][o][0] < 10){
					cout<<"{ "<<finalgatearray[u][o][0]<<",";
				}

				if (finalgatearray[u][o][1] >= 10){
					cout<<finalgatearray[u][o][1]<<"}";
				}  else if (finalgatearray[u][o][1] < 10){
					cout<<" "<<finalgatearray[u][o][1]<<"}";
				}
			}
		}
		cout<<endl;
	}
		cout<<endl;

	//function representation output
	for(int o =0; o < inout[0]*2; o++){ 
		for(int u =0; u < input_counter; u++){
			cout<<wirePCarray[u][o]<<", ";
		}
		cout<<endl;
	}
	cout<<endl;



/*
	for(int u =0; u < input_counter; u++)cout<<"....";
	cout<<endl;
	for(int o =0; o < inout[1]; o++){
		for(int u =0; u < input_counter; u++){
			 cout<<outputOcubes[u][o]<<", ";
		}
		cout<<endl;
	}
	cout<<endl;

*/

/*
	for(int o =0; o < (inout[0]*2); o++){ 
		for(int u =0; u < (input_counter*2); u++){
			if (finalgatearray[u][o][0] == -1 || o == 1){
				cout<<"{  ,  }";
			} else {
				if (finalgatearray[u][o][0] >= 10){
					cout<<"{"<<finalgatearray[u][o][0]<<",";
				} else if (finalgatearray[u][o][0] < 10){
					cout<<"{ "<<finalgatearray[u][o][0]<<",";
				}

				if (finalgatearray[u][o][1] >= 10){
					cout<<finalgatearray[u][o][1]<<"}";
				}  else if (finalgatearray[u][o][1] < 10){
					cout<<" "<<finalgatearray[u][o][1]<<"}";
				}
			}
		}
		cout<<endl;
	}
	
		cout<<endl;
		cout<<endl;


	for(int o =0; o < (inout[0]*2); o++){ 
		for(int u =0; u < (input_counter*2); u++){
			if (finalCgatearray[u][o][0] == -10 || finalCgatearray[u][o][0] == -1 || o == 1){
				cout<<"{  ,  }";
			} else {
				if (finalCgatearray[u][o][0] >= 10){
					cout<<"{"<<finalCgatearray[u][o][0]<<",";
				} else if (finalCgatearray[u][o][0] < 10){
					cout<<"{ "<<finalCgatearray[u][o][0]<<",";
				}
				if (finalCgatearray[u][o][2] >= 10){
					cout<<finalCgatearray[u][o][2]<<"}";
				}  else if (finalCgatearray[u][o][2] < 10){
					cout<<" "<<finalCgatearray[u][o][2]<<"}";
				}
			}
		}
		cout<<endl;
	}
		cout<<endl;
*/
	//count number of toffolis from finalCgatearray
	gatecost = 0;
	twobitg = 0;
	threebitg = 0;
	for(int u =0; u < (input_counter*2); u++){
		counter = 0;
		for(int o =0; o < (inout[0]*2); o++){ 
			//if (finalCgatearray[u][o][0] != -10 && finalCgatearray[u][o][0] != -1){
			if (finalgatearray[u][o][0] >-1 && o > 1){// && finalgatearray[u][o][0] != -1){
				counter++;
				if (finalgatearray[u][o][1] == -1){
				//if (finalCgatearray[u][o][0] >= finalCgatearray[u][o][2]){
					cout<<"{"<<finalgatearray[u][o][0]<<","<<finalgatearray[u][o][1]<<"}";
					twobitg++;
					gatecost += 1;
				} else {
					cout<<"{"<<finalgatearray[u][o][0]<<","<<finalgatearray[u][o][1]<<"}";
					threebitg++;
					gatecost += 5;
				}
			}
		}
	}
/*
	for(int u =2; u < (input_counter*2); u=u+2)
		if(finalCgatearray[u-2][top_controls[u-2]][0] == finalCgatearray[u][top_controls[u]][0] && finalCgatearray[u-2][top_controls[u-2]][2] == finalCgatearray[u][top_controls[u]][2]){
			gatecost = gatecost -10;
			gatecost = gatecost + 1;
			threebitg = threebitg - 2;
			twobitg = twobitg + 1;

		}
*/
/*	//count the number of Toffolis
	gatecost = 0;
	twobitg = 0;
	threebitg = 0;
	for (int u = 0; u < input_counter; u++){
		counter = 0;
		dcarecount = 0;
		ancilla = 0;
		m = 0;
		for (int v = 0; v < inout[0]; v++){
			if (wireCarray[u][v] == 'c' || wireCarray[u][v] == 'n'){
				counter++;
			} else if (wireCarray[u][v] == '-'){
				dcarecount++;
				if (counter == 0)
					ancilla++;
				else if (ancilla < 2 ) ancilla = 0;
			}
		}
		if(counter == 1 && dcarecount == 0){
			gatecost+=1;
			twobitg++;
			m++;
		} else if(counter == 0 && dcarecount == 1){
			gatecost+=1;twobitg++;
		} else {
			if (ancilla >= 2){
				if (counter <= 0){
					gatecost+=1;
					twobitg++;
					m++;
				} else {
					gatecost+=((counter)*5); 
					threebitg+=(counter);
					m+=(counter);
				}
			} else {
				if (dcarecount == 0 && counter >= 2){
					gatecost+=((counter-1)*5); 
					threebitg+=(counter-1);
					m+=(counter-1);
				} else {
					gatecost+=((counter)*5); 
					threebitg+=(counter);
					m+=(counter);
				}
			}
		}
	}

	for(int u =0; u < (input_counter*2); u=u+1){
		for(int o =1; o < (inout[0]*2); o++){ 
				if (finalCgatearray[u][o][0] != -1 && finalCgatearray[u][o][0] != -10){
					top_controls[u] = o;
					//cout<<"{"<<finalCgatearray[u][top_controls[u]][0]<<","<<finalCgatearray[u][top_controls[u]][2]<<"}, ";
					break;
				}
		}
	}
/*	cout<<" Total cost of the circuit (using approximate naive counting) is: "<<gatecost<<endl;
	cout<<" Total number of two bit gates is: "<<twobitg<<endl;
	cout<<" Total number of three bit gates is: "<<threebitg<<endl;
*/
/*
	for(int u =2; u < (input_counter*2); u=u+2)
		if(finalCgatearray[u-2][top_controls[u-2]][0] == finalCgatearray[u][top_controls[u]][0] && finalCgatearray[u-2][top_controls[u-2]][2] == finalCgatearray[u][top_controls[u]][2]){
			gatecost = gatecost -10;
			gatecost = gatecost + 1;
			threebitg = threebitg - 2;
			twobitg = twobitg + 1;

		}

*/
/*	cout<<" Total cost of the circuit (using approximate naive counting) is: "<<gatecost<<endl;
	cout<<" Total number of two bit gates is: "<<twobitg<<endl;
	cout<<" Total number of three bit gates is: "<<threebitg<<endl;
*/
	//calculate how many gates must be repeated - to restore ancilla bits
/*	for (int a = 0; a < input_counter; a++){
		//number of gates in this column
		gatearray[a] = 0;
		//number of control points of this column
		controlcounter[a] = 0;
		//indicates if this row is different than the previous one
		different[a] = false;
		//temporary ancilla bit
		ancillas[a] = -1;
		//the final array of gates - with doubled gates
		for (int b = 0;  b < inout[0]; b++)
			wireSarray[a][b] = " ";
	}
	for (int b = 0;  b < inout[0]; b++){
		//the vector of all control bits transparent
		variables[b] = ' ';
	}

	//calculate for the first two rows of tha array
	for (int b = 0; b < inout[0]; b++){
		for (int a = 0; a < input_counter; a++){

			for (int c = 0; c <= b; c++){
				if (wireCarray[a][c] == 'c' || wireCarray[a][c] == 'n' )
					variables[c] = wireCarray[a][c];
			}
			
			if (wireCarray[a][b] == 'c' || wireCarray[a][b] == 'n' ) {
				gatearray[a]++;
				if (a > 0)
					different[a] = true;
			}
			if (controlcounter[a] >= 2 && (wireCarray[a][b] == 'c' || wireCarray[a][b] == 'n' || wireCarray[a][b] == '-' )){
				ancillas[a] = (b+1);
				bottom = true;
				for (int y = b+1; y < inout[0]; y++)
					if (wireCarray[a][y] == 'c' || wireCarray[a][y] == 'n' || wireCarray[a][y] == '-' ){
						bottom  = false;
						break;
					}
				if (different[a] && b < (inout[0]-1) && !bottom){
					for (int i = a-1; i >= 0; i--){
						if (different[i] && (ancillas[a] == ancillas[i])){
							if (wireCarray[a][b] == '-')
								wireSarray[a][b] = variables[b]+wireSarray[a][b];
							else
								wireSarray[a][b] = wireCarray[i][b]+wireSarray[a][b];
							wireSarray[a][b] = r+wireSarray[a][b];	
							wireIarray[a][b] +=1;

							for (int j = b-1; j >= 0; j--){
								if (wireCarray[i][j] == 'c' || wireCarray[i][j] == 'n' || wireCarray[i][j] == '-' ){
									if (wireCarray[i][j] == '-')
										wireSarray[a][j] = variables[j]+wireSarray[a][j];
									else
										wireSarray[a][j] = wireCarray[i][j]+wireSarray[a][j];
									wireSarray[a][j] = r+wireSarray[a][j];
									wireIarray[a][j] +=1;
									break;
								}
							}
							break;					
						} else if (i == 0 && (ancillas[a] == ancillas[i])){
							if (wireCarray[a][b] == '-')
								wireSarray[a][b] = variables[b]+wireSarray[a][b];
							else
								wireSarray[a][b] = wireCarray[i][b]+wireSarray[a][b];

							wireSarray[a][b] = r+wireSarray[a][b];	
							wireIarray[a][b] +=1;

							for (int j = b-1; j >= 0; j--){
								if (wireCarray[i][j] == 'c' || wireCarray[i][j] == 'n' || wireCarray[i][j] == '-' ){
							if (wireCarray[i][j] == '-')
								wireSarray[a][j] = variables[j]+wireSarray[a][j];
							else
								wireSarray[a][j] = wireCarray[i][j]+wireSarray[a][j];

									wireSarray[a][j] = r+wireSarray[a][j];
									wireIarray[a][j] +=1;
									break;
								}
							}
							break;					
						}
					}
				}
			} else {
//				cout<<"{"<<controlcounter[a]<<","<<gatearray[a]<<","<<different[a]<<"}";
			}
			if (wireCarray[a][b] == 'c' || wireCarray[a][b] == 'n' || wireCarray[a][b] == '-' ) {
				controlcounter[a]++;
				wireIarray[a][b] +=1; 
				if (wireSarray[a][b].length() > 1){
					if (wireCarray[a][b] == '-'){
						wireSarray[a][b] += variables[b];
					} else
						wireSarray[a][b] += wireCarray[a][b];
				} else {
					wireSarray[a][b] += wireCarray[a][b];
				}
			}
		}
	}
	for(int o =0; o < (inout[0]); o++){ 
		for(int u =0; u < (input_counter); u++){
			cout<<"{ "<<wireCarray[u][o]<<"}";
		}
		cout<<endl;
	}
		cout<<endl;

		cout<<endl;
	//count the number of Toffolis
	gatecost = 0;
	twobitg = 0;
	threebitg = 0;
	counter = 0;
	for (int u = 0; u < input_counter; u++){
		counter = 0;
		dcarecount = 0;
		ancilla = 0;
		m = 0;
		for (int v = 0; v < inout[0]; v++){
			if (wireCarray[u][v] == 'c' || wireCarray[u][v] == 'n'){
				counter++;
			} else if (wireCarray[u][v] == '-'){
				dcarecount++;
				if (counter == 0)
					ancilla++;
				else if (ancilla < 2 ) ancilla = 0;
			}
		}
		if(counter == 1 && dcarecount == 0){
			gatecost+=1;
			twobitg++;
			m++;
		} else if(counter == 0 && dcarecount == 1){
			gatecost+=1;twobitg++;
		} else {
			if (ancilla >= 2){
				if (counter <= 0){
					gatecost+=1;
					twobitg++;
					m++;
				} else {
					gatecost+=((counter)*5); 
					threebitg+=(counter);
					m+=(counter);
				}
			} else {
			if (dcarecount == 0 && counter >= 2){
				gatecost+=((counter-1)*5); 
				threebitg+=(counter-1);
				m+=(counter-1);
			} else {
				gatecost+=((counter)*5); 
				threebitg+=(counter);
				m+=(counter);
			}
			}
		}
	}

	for(int u =0; u < (input_counter*2); u=u+1){
		for(int o =1; o < (inout[0]*2); o++){ 
				if (finalCgatearray[u][o][0] != -1 && finalCgatearray[u][o][0] != -10){
					top_controls[u] = o;
					//cout<<"{"<<finalCgatearray[u][top_controls[u]][0]<<","<<finalCgatearray[u][top_controls[u]][2]<<"}, ";
					break;
				}
		}
	}

	for(int u =2; u < (input_counter*2); u=u+2)
		if(finalCgatearray[u-2][top_controls[u-2]][0] == finalCgatearray[u][top_controls[u]][0] && finalCgatearray[u-2][top_controls[u-2]][2] == finalCgatearray[u][top_controls[u]][2]){
			gatecost = gatecost -10;
			gatecost = gatecost + 1;
			threebitg = threebitg - 2;
			twobitg = twobitg + 1;

		}

	cout<<" Total cost of the circuit (using approximate counting) is: "<<gatecost<<endl;
	cout<<" Total number of two bit gates is: "<<twobitg<<endl;
	cout<<" Total number of three bit gates is: "<<threebitg<<endl;
*/
//	cout<<endl;
/*	for(int u =0; u < (input_counter*2); u++){
		counter = 0;
		for(int o =0; o < (inout[0]*2); o++){ 
			if (finalCgatearray[u][o][0] != -10 && finalCgatearray[u][o][0] != -1){
				counter++;
				if (finalCgatearray[u][o][0] >= finalCgatearray[u][o][2]){
					twobitg++;
					gatecost += 1;
				} else {
					threebitg++;
					gatecost += 5;
				}
			}
		}
	}
*/
	cout<<" Total cost of the circuit (after minimization) is: "<<gatecost<<endl;
	cout<<" Total number of two bit function gates is: "<<(twobitg)<<endl;
	cout<<" Total number of three bit gates is: "<<(threebitg)<<endl;

	for (int y = 0; y < input_counter*4; y++){
		delete inputOcubes[y];
		delete wirearray[y];
		delete wireIarray[y];
		//delete wireCarray[y];
		delete finalarray[y];
		for (int x = 0; x < (inout[0]*2); x++){
			delete finalgatearray[y][x];
			delete finalCgatearray[y][x];
		}
		delete finalgatearray[y];
		delete finalCgatearray[y];
	}



	return gatecostmin;
}
/* compute the entropy on each input line */
int calculate_entropy(int input_counter, int **input_cubes, int *inout, int *variable_order){
        float line_stats [inout[0]];
        int zeros, ones, dc;
        for (int i = 0; i < inout[0]; i++){
                for (int j = 0; j < input_counter; j++){
                        if (input_cubes[j][i] == 0) zeros++;
                        else if (input_cubes[j][i] == 1) ones++;
                        else if (input_cubes[j][i] == -1 ) dc++;
                }
		zeros = zeros/input_counter;
		ones = ones/input_counter;
		dc = dc/input_counter;
		line_stats[i] = -(zeros*log(zeros)+ones*log(ones)+dc*log(dc));	
        }
}

/* compute statistics of don't cares vs. cares for each line */
int calculate_stats(int input_counter, int **input_cubes, int *inout, int *variable_order){
	float line_stats [inout[0]];
	int zeros, ones, dc;
	for (int i = 0; i < inout[0]; i++){
		for (int j = 0; j < input_counter; j++){
			if (input_cubes[j][i] == 0) zeros++;
			else if (input_cubes[j][i] == 1) ones++;
			else if (input_cubes[j][i] == -1 ) dc++;
		}
		zeros = zeros/input_counter;
		ones = ones/input_counter;
		dc = dc/input_counter;
		line_stats[i] = dc;
	}
}

int row_swap(int input_counter, int **input_cubes, int *inout, int *variable_order){
	int rowa = rand()%inout[0];
	int rowb = rand()%inout[0];
	int temp = 0;
	while (rowb == rowa)
		rowb = rand()%inout[0];
	for(int j = 0; j < input_counter; j++){
		temp = input_cubes[j][rowa];
		input_cubes[j][rowa] = input_cubes[j][rowb];
		input_cubes[j][rowb] = temp;
	}
	temp = variable_order[rowa];
	variable_order[rowa] = variable_order[rowb];
	variable_order[rowb] = temp;
	
}

int main(int argc, char *argv[]){
	int in, inn, val, m, n;
	int rand0, rand1;
	int inout[2];
	int input_counter = 0;
	int **inputcubes;
	int **outputcubes;
	int **inputcubes_for_process;
	int **outputcubes_for_process;
	int *variable_order;
	int *best_order;
	int best_threebit;
	int best_twobit;
	int *result;
	int best_cost = 1000000;
	int cost;
	ifstream pla_in_stream;
	string line;


	if (argc < 2) {cout<<"File argument needed"<<endl; exit(0);}
	pla_in_stream.open(argv[1]);	
	getline(pla_in_stream,line);
	
	while(line[0] != '.'){
		getline(pla_in_stream,line);
	}
	while(!pla_in_stream.eof()){
		if(line[0] == '.' && line[1] == 'i' && line[2] == ' '){

		}
		if(line[0] == '.' && line[1] == 'o' && line[2] == ' '){
		} else if(line[0] == '0' || line[0] == '1' || line[0]  == '-'){
			input_counter++;
		}
		getline(pla_in_stream,line);
	}


	inputcubes = new int*[input_counter];
	outputcubes = new int*[input_counter];
	inputcubes_for_process = new int*[input_counter];
	outputcubes_for_process = new int*[input_counter];
	result = new int[3];

	pla_in_stream.clear();              // forget we hit the end of file
	pla_in_stream.seekg(0, ios::beg);   // move to the start of the file
	read_pla_file(pla_in_stream, input_counter, inout, inputcubes, outputcubes);
	pla_in_stream.close();

	variable_order = new int[inout[0]];
	best_order = new int[inout[0]];

	for (int y = 0; y < input_counter; y++){
		inputcubes_for_process[y] = new int[inout[0]];
		outputcubes_for_process[y] = new int[inout[1]];
	}

	for (int y = 0; y < inout[0]; y++){
		variable_order[y] = y;
		best_order[y] = variable_order[y];
	}

	cout<<"Function name: "<<argv[1]<<endl;
	//test for various input variable permutations
	for (int a = 0; a <1; a++){
	//for (int a = 0; a <input_counter*inout[0]; a++){
	//for (int a = 0; a <1; a++){

		//copy the data to array used for p@rocessing the input data
		for (int y = 0; y < input_counter; y++){
			for(int o =0; o < inout[0]; o++)
				inputcubes_for_process[y][o] = inputcubes[y][o];
			for(int o =0; o < inout[1]; o++)
				outputcubes_for_process[y][o] = outputcubes[y][o];
		}
/*
		cout<<" input data "<<endl;
		for(int o =0; o < inout[0]; o++){ 
			for(int u =0; u < input_counter; u++){
				if (inputcubes[u][o] == -1)
					cout<<"2, ";
				else
					cout<<inputcubes[u][o]<<", ";
			}
			cout<<endl;
		}
		for(int u =0; u < input_counter; u++)cout<<"...";
		cout<<endl;
		for(int o =0; o < inout[1]; o++){
			for(int u =0; u < input_counter; u++){
				 cout<<outputcubes[u][o]<<", ";
			}
			cout<<endl;
		}
		cout<<endl;
*/
/*		cout<<"Ordering of the variables: ";
		for (int y = 0; y < inout[0]; y++)
			cout<<variable_order[y]<<" ";
		cout<<endl;
*/
		cost = process_pla(0, input_counter, inout, inputcubes_for_process, outputcubes_for_process, result);
		if (cost < best_cost){
			best_cost = result[0];
			best_threebit = result[1];
			best_twobit = result[2];
			for (int h = 0; h < inout[0]; h++)
				best_order[h] = variable_order[h];

			cout<<"---------- Best So Far ----------"<<endl;
			cout<<"Best Cost of the Circuit: "<<best_cost<<endl;
			cout<<"Number of Three bit gates: "<<best_threebit<<endl;
			cout<<"Number of Two bit gates: "<<best_twobit<<endl;

		}
		row_swap(input_counter, inputcubes, inout, variable_order);
	}

	cout<<"---------- Best Results ----------"<<endl;
	cout<<"Function name: "<<argv[1]<<endl;
	cout<<"Best Cost of the Circuit: "<<best_cost<<endl;
	cout<<"Number of Three bit gates: "<<best_threebit<<endl;
	cout<<"Number of Two bit gates: "<<best_twobit<<endl;
	cout<<"Ordering of the variables: ";
	for (int y = 0; y < inout[0]; y++)
		cout<<best_order[y]<<" ";
	cout<<endl;
	cout<<"---------- Best Results ----------"<<endl;
return 0;
}
