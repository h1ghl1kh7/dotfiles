function cd
    if string match -qr '^\.{3,}$' -- $argv
        # 점의 개수를 세어 상위 디렉토리로 이동
        set levels (math (string length -- $argv) - 2) # 점 개수 계산
        set path ..
        for i in (seq $levels)
            set path "$path/.."
        end
        builtin cd $path
    else
        # 기본 cd 동작 유지
        builtin cd $argv
    end
end
