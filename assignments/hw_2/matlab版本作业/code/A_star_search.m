function path = A_star_search(map,MAX_X,MAX_Y)
%%
%This part is about map/obstacle/and other settings
    %pre-process the grid map, add offset
    size_map = size(map,1);
    Y_offset = 0;
    X_offset = 0;
    
    %Define the 2D grid map array.
    %Obstacle=-1, Target = 0, Start=1
    MAP=2*(ones(MAX_X,MAX_Y));
    
    %Initialize MAP with location of the target
    xval=floor(map(size_map, 1)) + X_offset;
    yval=floor(map(size_map, 2)) + Y_offset;
    xTarget=xval;
    yTarget=yval;
    MAP(xval,yval)=0;
    
    %Initialize MAP with location of the obstacle
    for i = 2: size_map-1
        xval=floor(map(i, 1)) + X_offset;
        yval=floor(map(i, 2)) + Y_offset;
        MAP(xval,yval)=-1;
    end 
    
    %Initialize MAP with location of the start point
    xval=floor(map(1, 1)) + X_offset;
    yval=floor(map(1, 2)) + Y_offset;
    xStart=xval;
    yStart=yval;
    MAP(xval,yval)=1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %LISTS USED FOR ALGORITHM
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %OPEN LIST STRUCTURE
    %--------------------------------------------------------------------------
    %IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
    %--------------------------------------------------------------------------
    OPEN=[];
    %CLOSED LIST STRUCTURE
    %--------------
    %X val | Y val |
    %--------------
    % CLOSED=zeros(MAX_VAL,2);
    CLOSED=[];

    %Put all obstacles on the Closed list
    k=1;%Dummy counter
    for i=1:MAX_X
        for j=1:MAX_Y
            if(MAP(i,j) == -1)
                CLOSED(k,1)=i;
                CLOSED(k,2)=j;
                k=k+1;
            end
        end
    end
    CLOSED_COUNT=size(CLOSED,1);
    %set the starting node as the first node
    xNode=xval;
    yNode=yval;
    OPEN_COUNT=1;
    goal_distance=distance(xNode,yNode,xTarget,yTarget);
    path_cost=0;
    OPEN(OPEN_COUNT,:)=insert_open(xNode,yNode,xNode,yNode,goal_distance,path_cost,goal_distance);
    OPEN(OPEN_COUNT,1)=1;
    CLOSED_COUNT=CLOSED_COUNT+1;
    CLOSED(CLOSED_COUNT,1)=xNode;
    CLOSED(CLOSED_COUNT,2)=yNode;
    NoPath=1;

%%
%This part is your homework
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    while( sum(OPEN(:, 1))>0 ) %you have to dicide the Conditions for while loop exit 
        
     %
     %finish the while loop
     %
     
     % get the node with minimum cost
     idx = min_fn(OPEN,length(OPEN(:,1)),xTarget,yTarget);
     xNode = OPEN(idx, 2);
     yNode = OPEN(idx, 3);
     gNode = OPEN(idx, 7);
     
     OPEN(idx, 1)=0;
     
     % move the node to closed set
     CLOSED_COUNT = CLOSED_COUNT + 1;
     CLOSED(CLOSED_COUNT, 1) = xNode;
     CLOSED(CLOSED_COUNT, 2) = yNode;
     
     if xNode == xTarget && yNode == yTarget
         NoPath = 0;
         break;
     end
     
     % expand the search
     exp_array=expand_array(xNode, yNode, gNode, xTarget, yTarget, CLOSED, MAX_X, MAX_Y);
     
     for i=1:size(exp_array, 1)
         xChild = exp_array(i, 1);
         yChild = exp_array(i, 2);
         
         inOpen = 0;
         for j = 1:OPEN_COUNT
             if xChild == OPEN(j, 2) && yChild == OPEN(j, 3)
                 inOpen = 1;
                 
                 % update the cost
                 if gNode + distance(xNode,yNode,xChild,yChild) < OPEN(j,7)
                    OPEN(j, 4) = xNode;
                    OPEN(j, 5) = yNode;
                    OPEN(j, 7) = gNode + distance(xNode,yNode,xChild,yChild);
                    OPEN(j, 8) = OPEN(j,7) + OPEN(j,6);
                    
                 end
             end
         end
         
         if ~inOpen
             OPEN_COUNT = OPEN_COUNT + 1;
             hChild = distance(xChild, yChild, xTarget, yTarget);
             gChild = gNode + distance(xChild, yChild, xNode, yNode);
             fChild = hChild + gChild;
             
             OPEN(OPEN_COUNT,:)=insert_open(xChild,yChild,xNode,yNode,hChild,gChild,fChild);
         end
         
     end
     
    end %End of While Loop
    
    %Once algorithm has run The optimal path is generated by starting of at the
    %last node(if it is the target node) and then identifying its parent node
    %until it reaches the start node.This is the optimal path
    
    %
    %How to get the optimal path after A_star search?
    %please finish it
    %
    
   path = [];
   if NoPath
       return;
   else
       xval = xTarget;
       yval = yTarget;
       
       path = [path; xval, yval];
       while idx ~= 1
           idx = node_index(OPEN, xval, yval);
           
           xval = OPEN(idx, 4);
           yval = OPEN(idx, 5);
           
           path = [path; xval, yval];
       end
   end
   
   path = flip(path);
end
