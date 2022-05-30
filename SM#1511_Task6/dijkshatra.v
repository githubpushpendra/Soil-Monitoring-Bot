module PATH_PLANNING( 
input clk_50,start,
input [7:0]s_node,
input [7:0]e_node,
input node,
output [1:0] turn	
);

// States

parameter idle = 0,        //// in this state code will not execute to calculate shortest path
          path_st = 1,     /// in this state code will find shortest path
			 path_assign = 2, //// in this state code will assign found shortest path to the path[36:0] array
			 turn_assign = 3; //// in this state code will plan turning commands for every node in the way to reach to the destination node
			 

// reg declarations

reg [7:0] infinity = 300;
reg [7:0] snode = 0; // s = start
reg [7:0] enode = 0; // e = end
reg [7:0] arena_nodes[36:0][3:0];
reg [7:0] arena_costs[36:0][3:0];
reg [7:0] pnode[36:0];  // p = previous
reg [7:0] dypath[36:0];  // t = temporary
reg [7:0] path[36:0];
reg [7:0] lpath;  // l = lenght
reg [7:0] arena_x[36:0];
reg [7:0] arena_y[36:0];
reg [7:0] dynode; // dy = dynamic
reg [7:0] dynode2;
reg [7:0] dynode3;
reg [7:0] vnode[36:0]; //v = visited
reg [7:0] dnode[36:0]; // d = distance
reg [7:0] ddynode;     // distance of dynamic node from start node
reg [7:0] min_ddynode;
reg [1:0] direction[36:0];
reg [8*1:1] bot_orient = "E";   // initial orientation -> east
reg [8*1:1] bot_orient_next_node;
reg [8*1:1] goto;
reg [1:0] c_dir;
reg [1:0] left = 2'b01;
reg [1:0] right = 2'b10;
reg [1:0] straight = 2'b11;
reg [1:0] reverse = 2'b00;
reg [1:0] turn_reg;
reg go = 1;
reg startr = 0;
reg startr2 = 0;
reg [7:0]st; // current state

time t = 0;

// declaring flags

reg path_flag = 0;
reg path_assign_flag = 0;
reg turn_assign_flag = 0;

// integer declarations

integer i = 0;
integer j = 0;
integer k = 0;
integer l = 0;
integer m = 0;
integer x = 0;
integer dx , dy;

///////////////////// detecting start bit to start run of algo ///////////////////////////////////

always @(start) begin

   startr = start;

end

//assigning output

assign turn = turn_reg;


// updating start node and end node for which algo will give shortest path

always @(s_node or e_node) begin

   snode = s_node;
	enode = e_node;

end


// Initial Declarations

initial begin

// Storing Connected Nodes to the respective locations
  
    arena_nodes[0][0]=1;   arena_nodes[0][1]=2;   arena_nodes[0][2]=8;   arena_nodes[0][3]=37;
    arena_nodes[1][0]=0;   arena_nodes[1][1]=37;  arena_nodes[1][2]=37;  arena_nodes[1][3]=37;	
    arena_nodes[2][0]=0;   arena_nodes[2][1]=3;   arena_nodes[2][2]=4;   arena_nodes[2][3]=37;	
    arena_nodes[3][0]=2;   arena_nodes[3][1]=6;   arena_nodes[3][2]=17;	 arena_nodes[3][3]=37;	
    arena_nodes[4][0]=2;   arena_nodes[4][1]=5;   arena_nodes[4][2]=11;	 arena_nodes[4][3]=37;
    arena_nodes[5][0]=4;   arena_nodes[5][1]=37;  arena_nodes[5][2]=37;  arena_nodes[5][3]=37;
    arena_nodes[6][0]=3;   arena_nodes[6][1]=7;   arena_nodes[6][2]=14;  arena_nodes[6][3]=37;
    arena_nodes[7][0]=6;   arena_nodes[7][1]=37;  arena_nodes[7][2]=37;  arena_nodes[7][3]=37;
    arena_nodes[8][0]=0;   arena_nodes[8][1]=10;  arena_nodes[8][2]=33;  arena_nodes[8][3]=37;
    arena_nodes[9][0]=10;  arena_nodes[9][1]=37;  arena_nodes[9][2]=37;  arena_nodes[9][3]=37;
    arena_nodes[10][0]=8;  arena_nodes[10][1]=9;  arena_nodes[10][2]=11; arena_nodes[10][3]=37;
    arena_nodes[11][0]=4;  arena_nodes[11][1]=10; arena_nodes[11][2]=12; arena_nodes[11][3]=18;
    arena_nodes[12][0]=11; arena_nodes[12][1]=13; arena_nodes[12][2]=14; arena_nodes[12][3]=23;
    arena_nodes[13][0]=12; arena_nodes[13][1]=37; arena_nodes[13][2]=37; arena_nodes[13][3]=37;
    arena_nodes[14][0]=6;  arena_nodes[14][1]=12; arena_nodes[14][2]=15; arena_nodes[14][3]=37;
    arena_nodes[15][0]=14; arena_nodes[15][1]=16; arena_nodes[15][2]=17; arena_nodes[15][3]=37;
    arena_nodes[16][0]=15; arena_nodes[16][1]=37; arena_nodes[16][2]=37; arena_nodes[16][3]=37;
    arena_nodes[17][0]=3;  arena_nodes[17][1]=15; arena_nodes[17][2]=26; arena_nodes[17][3]=37;
    arena_nodes[18][0]=11; arena_nodes[18][1]=19; arena_nodes[18][2]=21; arena_nodes[18][3]=37;
    arena_nodes[19][0]=18; arena_nodes[19][1]=37; arena_nodes[19][2]=37; arena_nodes[19][3]=37;
    arena_nodes[20][0]=21; arena_nodes[20][1]=37; arena_nodes[20][2]=37; arena_nodes[20][3]=37;
    arena_nodes[21][0]=18; arena_nodes[21][1]=20; arena_nodes[21][2]=22; arena_nodes[21][3]=37;
    arena_nodes[22][0]=21; arena_nodes[22][1]=37; arena_nodes[22][2]=37; arena_nodes[22][3]=37;
    arena_nodes[23][0]=12; arena_nodes[23][1]=24; arena_nodes[23][2]=34; arena_nodes[23][3]=37;
    arena_nodes[24][0]=23; arena_nodes[24][1]=37; arena_nodes[24][2]=37; arena_nodes[24][3]=37;
    arena_nodes[25][0]=26; arena_nodes[25][1]=37; arena_nodes[25][2]=37; arena_nodes[25][3]=37;
    arena_nodes[26][0]=17; arena_nodes[26][1]=25; arena_nodes[26][2]=35; arena_nodes[26][3]=37;
    arena_nodes[27][0]=28; arena_nodes[27][1]=37; arena_nodes[27][2]=37; arena_nodes[27][3]=37;
    arena_nodes[28][0]=21; arena_nodes[28][1]=27; arena_nodes[28][2]=29; arena_nodes[28][3]=31;
    arena_nodes[29][0]=28; arena_nodes[29][1]=37; arena_nodes[29][2]=37; arena_nodes[29][3]=37;
    arena_nodes[30][0]=31; arena_nodes[30][1]=37; arena_nodes[30][2]=37; arena_nodes[30][3]=37;
    arena_nodes[31][0]=28; arena_nodes[31][1]=30; arena_nodes[31][2]=32; arena_nodes[31][3]=33;
    arena_nodes[32][0]=31; arena_nodes[32][1]=37; arena_nodes[32][2]=37; arena_nodes[32][3]=37;
    arena_nodes[33][0]=8;  arena_nodes[33][1]=31; arena_nodes[33][2]=34; arena_nodes[33][3]=37;
    arena_nodes[34][0]=23; arena_nodes[34][1]=33; arena_nodes[34][2]=35; arena_nodes[34][3]=37;
    arena_nodes[35][0]=26; arena_nodes[35][1]=34; arena_nodes[35][2]=36; arena_nodes[35][3]=37;
    arena_nodes[36][0]=35; arena_nodes[36][1]=37; arena_nodes[36][2]=37; arena_nodes[36][3]=37;
	 
// storing weight/cost of edges to the respective locations

	arena_costs[0][0]=1;  arena_costs[0][1]=2;         arena_costs[0][2]=3;         arena_costs[0][3]=infinity;
	arena_costs[1][0]=1;  arena_costs[1][1]=infinity;  arena_costs[1][2]=infinity;  arena_costs[1][3]=infinity;
	arena_costs[2][0]=2;  arena_costs[2][1]=3;         arena_costs[2][2]=2;         arena_costs[2][3]=infinity;
	arena_costs[3][0]=3;  arena_costs[3][1]=2;         arena_costs[3][2]=4;         arena_costs[3][3]=infinity;
	arena_costs[4][0]=2;  arena_costs[4][1]=1;         arena_costs[4][2]=2;         arena_costs[4][3]=infinity;
	arena_costs[5][0]=1;  arena_costs[5][1]=infinity;  arena_costs[5][2]=infinity;  arena_costs[5][3]=infinity;
	arena_costs[6][0]=2;  arena_costs[6][1]=1;         arena_costs[6][2]=3;         arena_costs[6][3]=infinity;
	arena_costs[7][0]=1;  arena_costs[7][1]=infinity;  arena_costs[7][2]=infinity;  arena_costs[7][3]=infinity;
	arena_costs[8][0]=3;  arena_costs[8][1]=2;         arena_costs[8][2]=4;         arena_costs[8][3]=infinity;
	arena_costs[9][0]=1;  arena_costs[9][1]=infinity;  arena_costs[9][2]=infinity;  arena_costs[9][3]=infinity;
	arena_costs[10][0]=2; arena_costs[10][1]=1;        arena_costs[10][2]=1;        arena_costs[10][3]=infinity;
	arena_costs[11][0]=2; arena_costs[11][1]=1;        arena_costs[11][2]=3;        arena_costs[11][3]=1;
	arena_costs[12][0]=3; arena_costs[12][1]=1;        arena_costs[12][2]=1;        arena_costs[12][3]=2;
	arena_costs[13][0]=1; arena_costs[13][1]=infinity; arena_costs[13][2]=infinity; arena_costs[13][3]=infinity;
	arena_costs[14][0]=3; arena_costs[14][1]=1;        arena_costs[14][2]=2;        arena_costs[14][3]=infinity;
	arena_costs[15][0]=2; arena_costs[15][1]=1;        arena_costs[15][2]=1;        arena_costs[15][3]=infinity;
	arena_costs[16][0]=1; arena_costs[16][1]=infinity; arena_costs[16][2]=infinity; arena_costs[16][3]=infinity;
	arena_costs[17][0]=4; arena_costs[17][1]=1;        arena_costs[17][2]=2;        arena_costs[17][3]=infinity;
	arena_costs[18][0]=1; arena_costs[18][1]=1;        arena_costs[18][2]=1;        arena_costs[18][3]=infinity;
	arena_costs[19][0]=1; arena_costs[19][1]=infinity; arena_costs[19][2]=infinity; arena_costs[19][3]=infinity;
	arena_costs[20][0]=1; arena_costs[20][1]=infinity; arena_costs[20][2]=infinity; arena_costs[20][3]=infinity;
	arena_costs[21][0]=1; arena_costs[21][1]=1;        arena_costs[21][2]=1;        arena_costs[21][3]=infinity;
	arena_costs[22][0]=1; arena_costs[22][1]=infinity; arena_costs[22][2]=infinity; arena_costs[22][3]=infinity;
	arena_costs[23][0]=2; arena_costs[23][1]=1;        arena_costs[23][2]=3;        arena_costs[23][3]=infinity;
	arena_costs[24][0]=1; arena_costs[24][1]=infinity; arena_costs[24][2]=infinity; arena_costs[24][3]=infinity;
	arena_costs[25][0]=1; arena_costs[25][1]=infinity; arena_costs[25][2]=infinity; arena_costs[25][3]=infinity;
	arena_costs[26][0]=2; arena_costs[26][1]=1;        arena_costs[26][2]=4;        arena_costs[26][3]=infinity;
	arena_costs[27][0]=1; arena_costs[27][1]=infinity; arena_costs[27][2]=infinity; arena_costs[27][3]=infinity;
	arena_costs[28][0]=1; arena_costs[28][1]=1;        arena_costs[28][2]=1;        arena_costs[28][3]=1;
	arena_costs[29][0]=1; arena_costs[29][1]=infinity; arena_costs[29][2]=infinity; arena_costs[29][3]=infinity;
	arena_costs[30][0]=1; arena_costs[30][1]=infinity; arena_costs[30][2]=infinity; arena_costs[30][3]=infinity;
	arena_costs[31][0]=1; arena_costs[31][1]=1;        arena_costs[31][2]=1;        arena_costs[31][3]=1;
	arena_costs[32][0]=1; arena_costs[32][1]=infinity; arena_costs[32][2]=infinity; arena_costs[32][3]=infinity;
	arena_costs[33][0]=4; arena_costs[33][1]=1;        arena_costs[33][2]=3;        arena_costs[33][3]=infinity;
	arena_costs[34][0]=3; arena_costs[34][1]=3;        arena_costs[34][2]=2;        arena_costs[34][3]=infinity;
	arena_costs[35][0]=4; arena_costs[35][1]=2;        arena_costs[35][2]=1;        arena_costs[35][3]=infinity;
	arena_costs[36][0]=1; arena_costs[36][1]=infinity; arena_costs[36][2]=infinity; arena_costs[36][3]=infinity;

// storing coordinates of nodes to the respective locations

	 arena_x[0]=0;	   arena_y[0]=120;
    arena_x[1]=5;	   arena_y[1]=120;
    arena_x[2]=0;	   arena_y[2]=130;
    arena_x[3]=0;	   arena_y[3]=150;
    arena_x[4]=10;	arena_y[4]=130;
    arena_x[5]=10;	arena_y[5]=135;
    arena_x[6]=10;	arena_y[6]=150;
    arena_x[7]=10;	arena_y[7]=155;
    arena_x[8]=20;	arena_y[8]=115;
    arena_x[9]=15;	arena_y[9]=125;
    arena_x[10]=20;	arena_y[10]=125;
    arena_x[11]=20;	arena_y[11]=130;
    arena_x[12]=20;	arena_y[12]=145;
    arena_x[13]=15;	arena_y[13]=145;
    arena_x[14]=20;	arena_y[14]=150;
    arena_x[15]=20;	arena_y[15]=160;
    arena_x[16]=15;	arena_y[16]=160;
    arena_x[17]=20;	arena_y[17]=170;
    arena_x[18]=25;	arena_y[18]=130;
    arena_x[19]=25;	arena_y[19]=135;
    arena_x[20]=30;	arena_y[20]=125;
    arena_x[21]=30;	arena_y[21]=130;
    arena_x[22]=30;	arena_y[22]=135;
    arena_x[23]=35;	arena_y[23]=145;
    arena_x[24]=35;	arena_y[24]=155;
    arena_x[25]=35;	arena_y[25]=165;
    arena_x[26]=35;	arena_y[26]=170;
    arena_x[27]=40;	arena_y[27]=125;
    arena_x[28]=40;	arena_y[28]=130;
    arena_x[29]=40;	arena_y[29]=135;
    arena_x[30]=45;	arena_y[30]=125;
    arena_x[31]=45;	arena_y[31]=130;
    arena_x[32]=45;	arena_y[32]=135;
    arena_x[33]=55;	arena_y[33]=130;
    arena_x[34]=55;	arena_y[34]=150;
    arena_x[35]=55;	arena_y[35]=155;
    arena_x[36]=50;	arena_y[36]=155; 	
																	
end									



always @(posedge clk_50) begin

   ///////// updating current state with some delay according to the need by time variable "t" //////////////


   t = t + 1;
	
	if(t > 20) t = 20;
	
	if(startr == 0) startr2 = 1;

   if(startr == 1 && startr2 == 1) begin
	 
	   startr2 = 0;
		st = path_st;
		t = 0;
	
	end
	
	case (st)
	
	path_st: begin
	
	   if(t > 10) begin
		
		   st = path_assign;
			t = 0;
		
		end
	
	end
	
	path_assign: begin
	
		if(t > 5) begin
		
		   st = turn_assign;
			t = 0;
		
		end
	
	end
	
	turn_assign: begin
	
	   if(t > 5) begin
		
		st = idle;
		t = 0;
		
		end
	
	end
	
	default: begin
	
	  t = 0;
	
	end
	
	endcase

////////////////////////////////// updating states ends here ///////////////////////////////////////



end	







always @(posedge clk_50) begin
		

   //////////////////////// main algo to find shortest path in the state path_st //////////////////////////////////////////////
	
   if((st == path_st) && (path_flag == 0)) begin	
	
	path_flag = 1;
	
   ////////////// preparing prerequisites --- storing default initial values to the distance of nodes from start node, previous node and visited node array //////////////
	
	for(i = 0; i < 37; i = i + 1) begin
	
	   dnode[i] = infinity;
		pnode[i] = 37;
	   vnode[i] = 0;
	end
	
	dnode[snode] = 0;      // distance of start node from the start node is zero
	pnode[snode] = snode;  // previous node of start node is start node
	
   ////////////// preparing prerequisites ends here //////////////
	
	dynode = snode;
	
	for(i = 0; i < 37; i = i + 1) begin   // loop will visit every node
	
		ddynode = dnode[dynode];    // distance of dynamic (temporary) node 
		min_ddynode = infinity;    // minimum distance of node connected to dynamic (temporary) node
		
		// assignig distances to the adjacent nodes
		
		for(j = 0; j < 4; j = j + 1) begin
		
		   if(ddynode + arena_costs[dynode][j] < dnode[arena_nodes[dynode][j]]) begin
			
			   dnode[arena_nodes[dynode][j]] = ddynode + arena_costs[dynode][j];
				pnode[arena_nodes[dynode][j]] = dynode;
			
			end
		
		end
		
		vnode[dynode] = 1;   // dynode is visited
		
		for(j = 0; j < 37; j = j + 1) begin   // finding least distant node (connected to the dynamic node) to to visited next
		
		   if((vnode[j] == 0) && (dnode[j] < min_ddynode)) begin
			
			   min_ddynode = dnode[j];
				dynode = j;
			
			end
 		
		end
		
	end
	
	end // path state closed here
	
	if(st == path_assign) path_flag = 0;   // lowering flag of state
	
	//////////////////////// main algo to find shortest path ends here //////////////////////////////////////////////
	
end







always @(posedge clk_50) begin

	//////////////////////////// assigning found shortest path to a array ///////////////////////////////////////////
	
	if((st == path_assign) && (path_assign_flag == 0)) begin // code will execute in path_assign state
	
	
	/////////////////// preparing prerequisites /////////////////////////////

	if(t == 2) begin
	
	for(k = 0; k < 37; k = k + 1) begin /// storing default value "37" to path array
	
	   path[k] = 37;
		dypath[k] = 37;
	
	end
	
	/////////////////// preparing prerequisites /////////////////////////////
	
	end
	
	if(t == 3)
	dynode3 = enode;
	
	if(t == 4) begin
	
	for(lpath = 0; lpath < 37; lpath = lpath + 1) begin  // lpath is length of path
	   
		if(dynode != snode) begin
	      dypath[lpath] = dynode3;
	      dynode3 = pnode[dynode3];
		end
	
	end
	
	end
	
	if(t == 5)
	dypath[lpath] = snode;
	
	if(t == 6) begin
	
	path_assign_flag = 1;
	
	for(k = 0; k < 37; k = k + 1) begin
	
	   if(dypath[lpath-k] < 37)
	      path[k] = dypath[lpath-k];
	
	end
	
	lpath = lpath + 1;
	
	end
	
	end //assign path closed here
	
	if(st == turn_assign) path_assign_flag = 0;
	
	//////////////////////////// assigning found shortest path to a array ends here ////////////////////////////////////

end






									
always @(posedge clk_50) begin

	
	/////////////////////////// assigning directions to go ///////////////////////////////////
	
	if((st == turn_assign) && (turn_assign_flag == 0)) begin

	turn_assign_flag = 1;
	
	// preparing prerequisite

	for(l = 0; l < 37; l = l + 1) begin
	
	   direction[l] = straight; // defalault direction is straight
	
	end
	
   // prerequisite state closed here
		
	dynode2 = path[0];
	
   for(l = 0, m = 1; (((l < 37) && m < 36) && path[m] < 37); l = l + 1, m = m + 1) begin		
		
		
	   dx = arena_x[path[m]] - arena_x[dynode2];  // defference between x coordinates of nodes where bot is and where to go
	   dy = arena_y[path[m]] - arena_y[dynode2];  // defference between y
		coordinates of nodes where bot is and where to go
	
      
		///////////////////////////////////////////// condition to go to west ////////////////////////////////////
		 
		/// bot_orient is current orientation of bot direction is orientation of bot to go to next node
		 
		if(dx < 0) begin
		
		   if(bot_orient == "W") begin
			   direction[l] = straight; 			
			end
			else if(bot_orient == "E") begin
				direction[l] = reverse ;		
			end
			else if(bot_orient == "S") begin
				direction[l] = left;		
			end
			else if(bot_orient == "N") begin
				direction[l] = right;		
			end
										
		   if(dy == 0) begin  
				
				bot_orient = "W";
			
			end
			
			else if(dy == 5) begin
			
			   bot_orient = "N";
			
			end
			
			else if(dy == -20) begin
			
			   bot_orient = "S";
			
			end
		
		end
		
		///////////////////////////////////////////// condition to go to west ends here ////////////////////////////////////
		
		///////////////////////////////////////////// condition to go to east ////////////////////////////////////
		
		else if(dx > 0) begin
		
		   if(bot_orient == "W") begin
			   direction[l] = reverse; 			
			end
			else if(bot_orient == "E") begin
				direction[l] = straight;		
			end
			else if(bot_orient == "S") begin
				direction[l] = right;		
			end
			else if(bot_orient == "N") begin
				direction[l] = left;		
			end
			
			if(dy == 0) begin
			
			   bot_orient = "E";
			
			end
			
			else if(dy == 15) begin
			
			   bot_orient = "N";
			
			end
			
			else if(dy == -15) begin
			
			   bot_orient = "S";
			
			end
		
		end
		
		
		///////////////////////////////////////////// condition to go to east ends here ////////////////////////////////////


		///////////////////////////////////////////// condition to go to south ////////////////////////////////////
		
		else if(dy < 0) begin
		
		   if(bot_orient == "W") begin
			   direction[l] = right; 			
			end
			else if(bot_orient == "E") begin
				direction[l] = left;		
			end
			else if(bot_orient == "S") begin
				direction[l] = straight;		
			end
			else if(bot_orient == "N") begin
				direction[l] = reverse;		
			end

			if(dx == 0) begin
			
			   bot_orient = "S";  
			
			end
			
			else if(dx == -35) begin
			
			   bot_orient = "W";
			
			end
			
			else if(dx == 15) begin
			
			   bot_orient = "E";
			
			end
		
		end
		
		///////////////////////////////////////////// condition to go to south ends here ////////////////////////////////////

		
		///////////////////////////////////////////// condition to go to north ////////////////////////////////////
		
		else if(dy > 0) begin
		
		   if(bot_orient == "W") begin
			   direction[l] = left; 			
			end
			else if(bot_orient == "E") begin
				direction[l] = right;		
			end
			else if(bot_orient == "S") begin
				direction[l] = reverse;		
			end
			else if(bot_orient == "N") begin
				direction[l] = straight;		
			end
		
		   if(dx == 0) begin
			
			   bot_orient = "N";
			
			end
			
			else if(dx == 20) begin
			
			   bot_orient = "E";
			
			end
			
			else if(dx == -20) begin
			
			   bot_orient = "W";
				
			end

		end
		
		///////////////////////////////////////////// condition to go to north ends here ////////////////////////////////////

 		dynode2 = path[m]; // asigning next node of path to the dynode2
		 
		end // assign_turn closed here
		
		end // for loop

      ////////////////////////// assigning directions to go ends here ///////////////////////////////////
		
		if(st == idle) turn_assign_flag = 0; // lowering flag of state
								
end

always @(posedge clk_50)begin
  if(node == 1 && go == 1) begin
    turn_reg = direction[x];
    x = x + 1;
	 go = 0;
  end
  
  if(node == 0) go = 1;

end									

endmodule 																	