set NODES;
set START within (NODES); 
set END within (NODES); 
set INTERMEDIATE within (NODES);

set EDGES within (NODES cross NODES);

param variable_costs{EDGES};
param capacity{EDGES};
param fixed_costs{EDGES}; 
param target_capacity;

var Bandwidth{EDGES} >= 0; 
var Enabled{EDGES} binary; 

# Funzione obiettivo
minimize total_costs:
    sum {(i,j) in EDGES}(fixed_costs[i,j]*Enabled[i,j]+variable_costs[i,j]*Bandwidth[i,j]);

# Conservazione del flow
subject to Start_Flow {s in START}:
    -sum {(s,n) in EDGES} Bandwidth[s,n] == -target_capacity;
subject to Intermediate_Flow {i in INTERMEDIATE}:
    sum {(n,i) in EDGES} Bandwidth[n,i] - sum {(i,m) in EDGES} Bandwidth[i,m] == 0;
subject to End_Flow {e in END}:
    sum {(n,e) in EDGES} Bandwidth[n,e] == target_capacity;

# Capacity constraint
subject to Link_Capacity {(i,j) in EDGES}:
    Bandwidth[i,j] <= capacity[i,j]*Enabled[i,j];

# Unique path constraint
subject to Unique_Path {a in NODES}:
    sum {(a,k) in EDGES} Enabled[a,k] <= 1;
    
    
