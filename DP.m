clc
clear 
close all

%% 定义 状态-阶段
stages = 5;
nodes_dist = cell(stages, 3);

nodes_dist{1, 1} = [1;];        % 第一列为当前阶段的状态，定义为行向量
nodes_dist{1, 2} = [1, 2, 3];   % 第二列为下一阶段的状态，定义为列向量
nodes_dist{1, 3} = [2, 5, 1];   % 第三列为当前阶段每个状态到下一阶段每个状态的距离，定义为矩阵

nodes_dist{2, 1} = [1; 2; 3];
nodes_dist{2, 2} = [1, 2, 3];
nodes_dist{2, 3} = [12, 14, 10;
                    6, 10, 4;
                    13, 12, 11];

nodes_dist{3, 1} = [1; 2; 3];
nodes_dist{3, 2} = [1, 2];
nodes_dist{3, 3} = [3, 9;
                    6, 5;
                    8, 10];

nodes_dist{4, 1} = [1; 2];
nodes_dist{4, 2} = [1];
nodes_dist{4, 3} = [5; 2];

nodes_dist{5, 1} = [1;];
nodes_dist{5, 2} = [0];
nodes_dist{5, 3} = [0];

%% 各状态最优路径及其距离值
path = cell(stages, 2);
dist = cell(stages, 2);
for i = 1 : stages
    dist{i, 1} = nodes_dist{i, 1};              % 第i阶段的所有状态
    dist{i, 2} = inf(length(dist{i, 1}), 1);    % 第i阶段各状态最优路径对应的距离
    path{i, 1} = nodes_dist{i, 1};              % 第i阶段的所有状态
    path{i, 2} = [];                            % 一个矩阵，每一行表示对应状态的最优路径
end
% 对最终状态进行特殊处理
dist{stages, 2} = 0;
path{stages, 2} = 1;

%% 逆向寻优
% 第一层循环，逆向遍历每一个阶段
for i = stages-1 : -1 : 1
    num_state_f = length(nodes_dist{i, 1});     % 第i阶段的状态量
    num_state_r = length(nodes_dist{i+1, 1});   % 第i+1阶段的状态量

    % 第二层循环，遍历第i阶段每一个状态
    for j = 1 : num_state_f

        % 第三层循环，对于第i阶段的第j状态，遍历i+1阶段的所有状态
        for k = 1:num_state_r
            dist_temp = nodes_dist{i, 3}(j, k) + dist{i+1, 2}(k);
            if dist_temp < dist{i, 2}(j)
                dist{i, 2}(j) = dist_temp;
                path{i, 2}(j, :) = [j ,path{i+1, 2}(k, :)];
            end
        end
    end
end

%% 正向求解
path_opt =  path{1, 2}
dist_opt =  dist{1, 2}