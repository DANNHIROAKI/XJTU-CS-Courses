function bayes_interactive_plot
    % 初始化变量
    pH = 0.5;
    pE = 0.1;
    LN = 0.2;
    LS = 1000.0;

    % 创建图形和轴
    fig = figure;
    ax = axes('Parent', fig);
    x = linspace(0, 1, 1000);
    y = EH(x, pH, pE, LN, LS);
    hPlot = plot(ax, x, y);

    % 对于每个 pE 值生成一个图形
    for n = 1:9
        pE = 0.1 * n; % 设置 pE 值

        % 创建图形和轴
        fig = figure;
        ax = axes('Parent', fig);
        y = EH(x, pH, pE, LN, LS);
        hPlot = plot(ax, x, y);
        title(ax, sprintf('段弘毅-2213611582 (pE = %.1f)', pE));

        % pH 文本框和标签
        uicontrol('Style', 'text', 'Position', [100, 350, 60, 20], 'String', 'pH');
        pHBox = uicontrol('Style', 'edit', 'Position', [160, 350, 60, 20], 'String', '0.5', 'Callback', {@updatePlot, 'pH'});

        % pE 文本框和标签
        uicontrol('Style', 'text', 'Position', [100, 320, 60, 20], 'String', 'pE');
        pEBox = uicontrol('Style', 'edit', 'Position', [160, 320, 60, 20], 'String', pE, 'Callback', {@updatePlot, 'pE'});

        % LS 文本框和标签
        uicontrol('Style', 'text', 'Position', [100, 290, 60, 20], 'String', 'LS');
        LSBox = uicontrol('Style', 'edit', 'Position', [160, 290, 60, 20], 'String', '1000.0', 'Callback', {@updatePlot, 'LS'});

        % LN 文本框和标签
        uicontrol('Style', 'text', 'Position', [100, 260, 60, 20], 'String', 'LN');
        LNBox = uicontrol('Style', 'edit', 'Position', [160, 260, 60, 20], 'String', '0.2', 'Callback', {@updatePlot, 'LN'});
    end


    function y = EH(x, pH, pE, LN, LS)
        % 计算更新后的概率值
        pH_E = (LS * pH) / ((LS - 1) * pH + 1);
        pH_negE = (LN * pH) / ((LN - 1) * pH + 1);
        
        y = zeros(size(x));
        for i = 1:length(x)
            pE_S = x(i);
            if pE_S <= pE
                y(i) = pH_negE + (pH - pH_negE) / pE * pE_S;
            elseif pE_S > pE
                y(i) = pH + (pH_E - pH) / (1 - pE) * (pE_S - pE);
            end
        end
    end

    function updatePlot(source, ~, paramName)
        % 根据用户输入更新图形
        newVal = str2double(source.String);
        switch paramName
            case 'pH'
                pH = newVal;
            case 'pE'
                pE = newVal;
            case 'LS'
                LS = newVal;
            case 'LN'
                LN = newVal;
        end
        y = EH(x, pH, pE, LN, LS);
        set(hPlot, 'YData', y);
    end
end