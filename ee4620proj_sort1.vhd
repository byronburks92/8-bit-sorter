-- ee4620proj_sort1.vhd

--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------

library IEEE,WORK;
        use IEEE.STD_LOGIC_1164.ALL;
        use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity COMP_2bit1 is
       port(A1,A0,B1,B0: in std_logic;
                Z: out std_logic);
end; 

architecture BEHAV of COMP_2bit1 is
-- checks if A1,A0 is equal to B1,B0

begin

Z <= (A1 xor B1) and (A0 xor B0);

end;


library IEEE,WORK;
        use IEEE.STD_LOGIC_1164.ALL;
        use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity COMP_2bit2 is
        port(A1,A0,B1,B0: in std_logic;
                Z: out std_logic);
end; 

architecture BEHAV of COMP_2bit2 is
-- checks if A1,A0 is greater than B1,B0

begin

Z <= (A1 and not(B1)) or (A0 and not(B1) and not(B0)) or (A1 and A0 and not(B0));

end;

library IEEE,WORK;
        use IEEE.STD_LOGIC_1164.ALL;
        use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity COMP_8bit is
        port(A7,A6,A5,A4,A3,A2,A1,A0,B7,B6,B5,B4,B3,B2,B1,B0: in std_logic;
                Z: out std_logic);
end; 

architecture BEHAV of COMP_8bit is

component COMP_2bit1
    port(A1,B1,A0,B0: in std_logic;
       Z: out std_logic);
end component;

component COMP_2bit1
    port(A1,B1,A0,B0: in std_logic;
       Z: out std_logic);
end component;
-- any internal signal declarations
signal Z0int,Z1int,Z2int,stop1:std_logic;

begin
 

process
stop1 <= '0';

if not(stop1)
    G1:COMP_2bit1 port map(A1=>A7,B1=>B7,A0=>A6,B0=>B6,Z=>Z0int);
    if Z0int = '0'
        G2:COMP_2bit2 port map(A1=>A7,B1=>B7,A0=>A6,B0=>B6,Z=>Z);
        stop1 <= '1';
    end if;
end if;

if not(stop1)
    G3:COMP_2bit1 port map(A1=>A5,B1=>B5,A0=>A4,B0=>B4,Z=>Z1int);
    if Z1int = '0'
        G4:COMP_2bit2 port map(A1=>A5,B1=>B5,A0=>A4,B0=>B4,Z=>Z);
        stop1 <= '1';
    end if;
end if;

if not(stop1)
    G5:COMP_2bit1 port map(A1=>A3,B1=>B3,A0=>A2,B0=>B2,Z=>Z2int);
    if Z2int = '0'
        G6:COMP_2bit2 port map(A1=>A3,B1=>B3,A0=>A2,B0=>B2,Z=>Z);
        stop1 <= '1';
    end if;
end if;

if not(stop1)
    G7:COMP_2bit2 port map(A1=>A1,B1=>B1,A0=>A0,B0=>B0,Z=>Z);
end if;

end process;
end;

--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------
library IEEE,WORK;
        use IEEE.STD_LOGIC_1164.ALL;
        use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity SORTER_8bit is
        generic(N:integer:=10);
        generic(Ng:integer:=7);
        port(   X: in std_logic_2d(0 to N-1);
                Gaps: in integer(0 to Ng-1);
                Y: out std_logic_2d(0 to N-1));
end;

architecture BEHAV of SORTER_8bit is

  -- declarative area
  
type std_logic_2d is array range of std_logic_vector(7 downto 0);

component COMP_8bit
    port(A7,A6,A5,A4,A3,A2,A1,A0,B7,B6,B5,B4,B3,B2,B1,B0: in std_logic;
                Z: out std_logic);
end component;

signal A,B:std_logic_vector(7 downto 0);
signal Z:std_logic;

begin

  -- instantiation area
process

-- gaps = calc_gaps(N, 1.3, extra1=1)

-- num_4luts = 0

-- for k1 in range(len(gaps)):
    -- gapk = gaps[k1]
    -- for k2 in range(N - gapk):
        -- z1, n4 = comp8bit(X[k2 + gapk], X[k2])
        -- if z1 == '1':
            -- temp = X[k2]
            -- X[k2] = X[k2 + gapk]
            -- X[k2 + gapk] = temp
        -- else:
            -- pass
            
Y <= X;

for k1 in 0 to Ng-1 loop
    for k2 in 0 to N-Gaps(k1)-1 loop
        A <= X(k2 + Gaps(k1));
        B <= X(k2);
        G1:COMP_8bit port map(A7=>A(7),A6=>A(6),A5=>A(5),A4=>A(4),A3=>A(3),A2=>A(2),A1=>A(1),A0=>A(0),B7=>B(7),B6=>B(6),B5=>B(5),B4=>B(4),B3=>B(3),B2=>B(2),B1=>B(1),B0=>B(0),Z=>Z);
        if Z = '1'
            Y(k2) <= A;
            Y(k2 + Gaps(k1)) <= B;
        end if;
    end loop;
end loop;

end process;
end;
