/***************************************************************************
*   Copyright (C) 2006 by martin lukac   				  *
*   lukacm@ece.pdx.edu   						  *
*                                                                         *
*   This program is free software; you can redistribute it and/or modify  *
*   it under the terms of the GNU General Public License as published by  *
*   the Free Software Foundation; either version 2 of the License, or     *
*   (at your option) any later version.                                   *
*                                                                         *
*   This program is distributed in the hope that it will be useful,       *
*   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
*   GNU General Public License for more details.                          *
*                                                                         *
*   You should have received a copy of the GNU General Public License     *
*   along with this program; if not, write to the                         *
*   Free Software Foundation, Inc.,                                       *
*   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
***************************************************************************/
//Uncomment to allow multi-threaded computation for smaller circuits 8 < qubits
//#define __SSIZE__
//Uncoment to allow QMDD representation for circuits up to 7 qubits
//#define __QMDD__
//Uncoment to unleash the standard things
//#define __STDR__
//#define __TIMING__

#include <iostream>
#include <string>
#include <fstream>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cmath>
#include <time.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>
#include <pthread.h>
#include <complex>
#include <sstream>

//#include <cutil.h>
//#include <cutil_inline.h>
//#include "cublas.h"
//#include "cuda.h"

#include <gsl_cblas.h>
#include <gsl_complex_math.h>
#include <gsl_permutation.h>
#include <gsl_blas.h>
#include <gsl_linalg.h>

using namespace std;

// Thread block size
#define MAXGATEINPUT 20
#define BLOCK_SIZE 2

// max number of of inputs
const int MAXVARS = 100;
// max number of generated base functions
const int MAXGEN = 1000000;	

//int base_functions;
// input file stream
static ifstream in_stream;	
// output file stream
static ofstream out_stream;	

typedef struct Bfunction {
	gsl_matrix * matrix; //original matrix
	gsl_matrix * inverse; //inverse matrix
	gsl_matrix * ludecomp; //LU decomposition
	int size; //number of inputs
	double det; // determinant
	gsl_permutation * perm; // permutation matrix
} Bfunction;

typedef struct qGate
{
// number of input/output wires
	int numIO;		
	int realIO;		
// cost of the gate
	int Cost;		
// representation
	int representation;
// matrix representing this gate
	int *gateMatrix1;	
//The String Name of this gate
	string my_string;	
	int valuedness;
	int restrictions_number;
	//specifies wich wires can be used as placement for this gate
	int restrictions[MAXGATEINPUT];
	int connections[MAXGATEINPUT];
} qGate;

typedef struct MCT {
	short *controls;
	short target;
} MCT;

typedef struct Kmap {
	gsl_matrix * function;
	int inputs;
} Kmap;


typedef struct Mresult
{
	int results;
	gsl_matrix ** resulting_bfunctions;
	gsl_matrix ** resulting_inv_bfunctions;
	gsl_matrix ** resulting_bfunction_kmap;
} Mresult;

typedef struct result
{
	float avFitness [100000];
	float avError[100000];
	float avCost[100000];
	int counter;
	int step;
} result;

typedef struct Solution
{
	int ioNumber;
	float error;
	float fitness;
	float cost;
	string my_string;
} Solution;

void read_pla(string);
int read_pla_file(const char*, int*, int**, int**);	

