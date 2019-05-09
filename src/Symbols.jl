"""
The  combinatorial objects  in this  module are  *partitions*, *β-sets* and
*symbols*.

A partition is a decreasing list of strictly positive integers p₁≥p₂≥…pₙ>0,
represented as a `Vector` of `Int`.

A  *β-set* is  a set  of positive  integers, up  to the *shift* equivalence
relation.  This  equivalence  relation  is  the  transitive  closure of the
elementary  equivalence  of  [s₁,…,sₙ]  and [0,1+s₁,…,1+sₙ]. An equivalence
class  has exactly one  member which does  not contain 0:  it is called the
normalized  β-set. A β-set is represented as a strictly increasing `Vector`
of `Int`.

To  a  partition  p₁≥p₂≥…pₙ>0  is  associated  a  β-set,  whose  normalized
representative   is  pₙ,pₙ₋₁+1,…,p₁+n-1.  Conversely,   to  each  β-set  is
associated  a partition, the one giving by the above formula its normalized
representative.

A  symbol is  a tuple  S=[S₁,…,Sₙ] of  β-sets, taken modulo the equivalence
relation  generated by two elementary  equivalences: the simultaneous shift
of  all β-sets, and the cyclic permutation  of the tuple (in the particular
case  where n=2 it is thus an unordered pair of β-sets). This time there is
a  unique normalized symbol where 0 is not in the intersection of the Sᵢ. A
basic invariant attached to symbols is the *rank*, defined as

`sum(sum,S)-div((sum(length,S)-1)*(sum(length,S)-length(S)+1),2*Length(S))`

Another  function attached to symbols  is the *shape* 'map(length,S)'; when
n=2  one can  assume that  S₁ has  at least  the same  length as S₂ and the
difference  of cardinals 'length(S[1])-length(S[2])',  called the *defect*,
is then an invariant of the symbol.

Partitions  and pairs  of partitions  are parameters  for characters of the
Weyl groups of classical types, and tuples of partitions are parameters for
characters  of  imprimitive  complex  reflection  groups.  Symbols with two
β-sets  are parameters for the  unipotent characters of classical Chevalley
groups,  and more general  symbols for the  unipotent characters of Spetses
associated  to complex  reflection groups.  The rank  of the  symbol is the
semi-simple rank of the corresponding Chevalley group or Spets.

Symbols of rank n and defect 0 parameterize characters of the Weyl group of
type  Dₙ, and  symbols of  rank n  and defect  divisible by  4 parameterize
unipotent characters of split orthogonal groups of dimension 2n. Symbols of
rank n and defect congruent to 2 mod 4 parameterize unipotent characters of
non-split orthogonal groups of dimension 2n. Symbols of rank n and defect 1
parameterize  characters of the Weyl group  of type Bₙ, and finally symbols
of  rank n and  odd defect parameterize  unipotent characters of symplectic
groups of dimension 2n or orthogonal groups of dimension 2n+1.
"""
module Symbols
using Gapjm
export shiftβ, βSet, partβ, symbol_partition_tuple,
valuation_gendeg_symbol, degree_gendeg_symbol,
degree_feg_symbol, valuation_feg_symbol,
defectsymbol, fullsymbol, ranksymbol, symbols, fegsymbol, stringsymbol,
Tableaux

"""
`shiftβ( β, n)` shift β-set β by n

```julia-repl
julia> shiftβ([4,5],3)
5-element Array{Int64,1}:
 0
 1
 2
 7
 8

julia> shiftβ([0,1,4,5],-2)
2-element Array{Int64,1}:
 2
 3

```
"""
function shiftβ(β,n=1)
  if n>=0 return [0:n-1;β .+ n]
  elseif β[1:-n]!= 0:-n-1 error("Cannot shift $β by $n\n")
  else return β[1-n:end].+n
  end
end

"""
`βSet(p)` normalized β-set of a partition
    
```julia-repl
julia> βSet([3,3,1])
3-element Array{Int64,1}:
 1
 4
 5
```
"""
βSet(α)=isempty(α) ? α : reverse(α) .+(0:length(α)-1)

"""
'partβ(β)' partition defined by β-set β

```julia-repl
julia> partβ([0,4,5])
2-element Array{Int64,1}:
 3
 3
```
"""
partβ(β)=filter(x->!iszero(x),reverse(β.-(0:length(β)-1)))

"""
`symbol_partition_tuple(p, s)` symbol of shape `s` for partition tuple `p`.

In  the most  general case,  `s` is  a `Vector`  of positive `Int`s of same
length  as `p` and the  β-sets for `p` are  shifted accordingly (a constant
integer may be added to `s` to make the shifts possible).

When  `s` is  a positive  integer it  is interpreted  as `[s,0,0,…]`  and a
negative  integer is interpreted  as `[0,-s,-s,…]` so  when `p` is a double
partition  one gets the  symbol of defect  `s` associated to  `p`; as other
uses  the principal  series of  `G(e,1,r)` is `symbol_partition_tuple(p,1)`
and that of `G(e,e,r)` is `symbol_partition_tuple(p,0)`.

Note. The function works also for periodic `p` for `G(e,e,r)` provided `s=0`.

```julia-repl
julia> symbol_partition_tuple([[1,2],[1]],1)
2-element Array{Array{Int64,1},1}:
 [2, 2]
 [1]   

julia> symbol_partition_tuple([[1,2],[1]],0)
2-element Array{Array{Int64,1},1}:
 [2, 2]
 [0, 2]

julia> symbol_partition_tuple([[1,2],[1]],-1)
2-element Array{Array{Int64,1},1}:
 [2, 2]   
 [0, 1, 3]
```
"""
function symbol_partition_tuple(p,s)
  if p[end] isa Number
    l= length(p) - 2
    e= l*p[end-1]
  else e=l=length(p)
  end
  if s isa Integer
    if s<0  s=[0;fill(-s,l-1)]
    else    s=[s;zeros(Int,l-1)]
    end
  else s=s[1:l]
  end
  s= map(length, p[1:l]) .- s
  s= maximum(s) .- s
  p= copy(p)
  p[1:l]=map(i->shiftβ(βSet(p[i]),s[i]),1:l)
  p
end

function fullsymbol(S)
  if isempty(S) || S[end] isa AbstractVector return S end
  vcat(map(i->map(copy,S[1:end-2]),1:S[end-1])...)
end

"""
`ranksymbol(S)` rank of symbol `S`.

```julia-repl
julia> ranksymbol([[1,2],[1,5,6]])
11
```
"""
function ranksymbol(s)
  s=fullsymbol(s)
  ss=sum(length,s)
  if isempty(s) return 0 end
  e=length(s)
  sum(sum,s)-div((ss-1)*(ss-e+1),2*e)
end

function valuation_gendeg_symbol(p)
  p=fullsymbol(p)
  e=length(p)
  p=sort!(vcat(p...))
  m=length(p)
  sum(p.*(m-1:-1:0))-div(m*(m-e)*(2*m-3-e),12*e)
end

function degree_gendeg_symbol(p)
  p=fullsymbol(p)
  r=ranksymbol(p)
  e=length(p)
  p=sort!(vcat(p...))
  m=length(p)
  if mod(m,e)==1 r=div(e*r*(r+1),2)
  else           r+= div(e*r*(r-1),2)
  end
  r+sum(p.*(0:m-1))-sum(x->div(e*x*(x+1),2),p)-div(m*(m-e)*(2*m-3-e),12*e)
end

function defectsymbol(S)
 S[end] isa AbstractVector && length(S)>1 ? length(S[1])-length(S[2]) : 0
end

function degree_feg_symbol(s,p=length(fullsymbol(s)))
  s=fullsymbol(s)
  e=length(s)
  d=defectsymbol(s)
  if !(d in [0,1]) return -1 end
  r=ranksymbol(s)
  if d==1 res=div(e*r*(r+1),2)
  else    res=div(e*r*(r-1),2)+r
  end
  res+=e*sum(S->sum(S.*(0:length(S)-1))-sum(l->div(l*(l+1),2),S),
               filter(x->!isempty(x),s))
  gamma=i->sum(mod.(i+(0:e-1),e).*map(sum,s))
  if d==1 res+=gamma(0)
  else res+=maximum(gamma.(0:e-1))
  end
  res-sum(map(x->div(x*(x-1),2),e*(1:div(sum(length,s),e)-1).+mod(d,2))) 
end

function valuation_feg_symbol(s)
  s=fullsymbol(s)
  d=defectsymbol(s)
  if !(d in [0,1]) return -1 end
  e=length(s)
  res=e*sum(S->sum(S.*(length(S)-1:-1:0)),filter(x->!isempty(x),s))
  gamma=i->sum(mod.(i+(0:e-1),e).*map(sum,s))
  if d==1 res+=gamma(0)
  else res+=minimum(gamma.(0:e-1))
  end
  res-sum(map(x->div(x*(x-1),2),e*(1:div(sum(length,s),e)-1).+mod(d,2))) 
end

IntListToString(l)=any(x->x>10,l) ? join(l,",") : join(l)

" stringsymbol(S) string for symbol S"
function stringsymbol(S)
  if isempty(S) return "()" end
  if S[end] isa AbstractVector 
    return "("*join(IntListToString.(S),",")*")"
  else
    v=E(S[end-1])^S[end]
    n= v==1 ? "+" : v==-1 ? "-" : string(v)
   return "("*join(IntListToString.(S[1:end-2]),",")*"$n)"
  end
end

"""
  lesssymbols( <x>, <y> )  < for symbols
  
  A symbol is smaller than another if the shape is lexicographically smaller,
  or the shape is the same and the the symbol is lexicographically bigger
"""
function lesssymbols(x,y)
  map(length,x)<map(length,y) || (map(length,x)==map(length,y) && x>y)
end

"""
`symbols(e,r,c)` e-symbols of rank r and content=c mode e

The content of a symbol `S`is `sum(length,S)%length(S)`.
The symbols for unipotent  characters of  `G(d,1,r)` are  `symbols(d,r,1)`
and those for unipotent characters of `G(e,e,r)` are `symbols(e,r,0)`.

```julia-repl
julia> stringsymbol.(symbols(3,2,1))
14-element Array{String,1}:
 "(12,0,0)"   
 "(02,1,0)"   
 "(02,0,1)"   
 "(012,12,01)"
 "(01,1,1)"   
 "(012,01,12)"
 "(2,,)"      
 "(01,2,0)"   
 "(01,0,2)"   
 "(1,012,012)"
 "(,02,01)"   
 "(,01,02)"   
 "(0,,012)"   
 "(0,012,)"   

julia> stringsymbol.(symbols(3,3,0))
10-element Array{String,1}:
 "(1,1,1)"      
 "(01,12,02)"   
 "(01,02,12)"   
 "(012,012,123)"
 "(0,1,2)"      
 "(0,2,1)"      
 "(01,01,13)"   
 "(0,0,3)"      
 "(012,,)"      
 "(012,012,)"   
```
"""
function symbols(e,r,c=1)
  function defShape(s)local e
    e=length(s)
    (binomial(e,2)*div(sum(s),e)-sum(i->(i-1)*s[i],1:e))%e
  end
 
  function IsReducedSymbol(s)
    all(1:length(s)-1)do i
      x=circshift(s,i)
      return x==s || lesssymbols(x,s)
      end
  end

  shapesSymbols=function(r,e,c)local f,res,m,new
    f=function(lim2,sum,nb,max)local res,a
      if nb==1   
        if sum==0   return [[sum]]
        else return Vector{Int}[] end 
      end
      res=Vector{Int}[]
      a=div(sum,nb-1)
      while a<=max  &&  binomial(a,2)<=lim2  &&  a<=sum  
        append!(res,map(x->vcat([a],x),f(lim2-binomial(a,2),sum-a,nb-1,a)))
        a+=1 
      end
      return res
    end

    res=[]
    m=0
    while true
      new=f(r+div((m*e+c-1)*(m*e+c-e+1),2*e),c+m*e,e,c+m*e)
      append!(res,new)
      m+=1
      if length(new)==0 break end
    end
    res=vcat(map(x->arrangements(x,e),res)...)
    filter(s->defShape(s)==0  &&  
      all(x->defShape(x)!=0  ||  x<=s,map(i->circshift(s,i),1:length(s)-1)),res)
  end

  c=c%e
  S=vcat(map(shapesSymbols(r,e,c)) do s
    map(x->symbol_partition_tuple(x,s),
       partition_tuples(r-ranksymbol(map(x->0:x-1,s)),e)) end...)
  !iszero(c) ? S : filter(IsReducedSymbol,S)
end

# When given a second argument p dividing e, works for the coset G(e,e,r).s_1^p
# See Malle, "Unipotente Grade", 2.11 and 5.7
"""
`fegsymbol(S)` returns as a CycPol the fake degree given by symbol `S`

```julia-repl
julia> fegsymbol([[1,5,6],[1,2]])
q¹⁶Φ₅Φ₇Φ₈Φ₉Φ₁₀Φ₁₁Φ₁₄Φ₁₆Φ₁₈Φ₂₀Φ₂₂
```
"""
function fegsymbol(s,p=0)
  q=Pol([1],1)
  if isempty(s) return one(CycPol) end
  s=fullsymbol(s)
  e=length(s)
  r=ranksymbol(s)
  p= p==0 ? 1 : E(e,p)
  function delta(S)
    l=length(S)
    if l<2 return one(CycPol) end
    prod(CycPol(q^(e*S[j])-q^(e*S[i])) for i in 1:l for j in i+1:l)
  end
  function theta(S)
    s1=filter(x->x>0,S)
    if isempty(s1) return one(CycPol) end
    prod(l->prod(h->CycPol(q^(e*h)-1),1:l),s1)
  end
  d=defectsymbol(s)
  if d==1 res=theta([r])
  elseif d==0 res=theta([r-1])*CycPol(q^r-p)
  else return zero(CycPol)
  end
  res*=prod(S->delta(S)//theta(S),s)
  res//=CycPol(q^sum([div(x*(x-1),2) for x in e*(1:div(sum(length,s),e)-1)+d%2]))
  if d==1 res*=CycPol(q^sum(map((x,y)->x*sum(y),0:e-1,s)))
  else
    rot=circshift.(Ref(s),0:e-1)
    res*=div(CycPol(sum(map(j->p^j,0:e-1).* map(s->q^sum((0:e-1).*map(sum,s)),
                                                rot))),count(i->i==s, rot))
    if e == 2 && p == -1 res=-res end
  end
  if r==2 && (e>2 && p==E(e)) res=CycPol(res(E(2e)*q)//E(2e, degree(res))) end
  return res
end

function Tableaux(S::Vector{Int})
  first.(Tableaux([S]))
end

# list of standard tableaux of shape the partition-tuple S (that is, a filling
# of S with the numbers [1..Sum(S,Sum)] such that the numbers increase across
# the rows and down the columns).
# If S is a single partition return single tableaux.
function Tableaux(S)
  if isempty(S) return S end
  w=sum(sum,S)
  if w==0 return [map(x->map(y->Int[],x),S)] end
  res=vcat(map(function(i) local rim, l
    l=length(S[i])
    rim = filter(j->S[i][j+1]<S[i][j],1:l-1)
    if l!=0 && S[i][l]!=0 push!(rim,l) end
    return vcat(map(function(p)
          n=deepcopy(S)
          n[i][p]-=1
          n=Tableaux(n)
          for t=n push!(t[i][p], w) end
          return n
      end, rim)...)
    end, 1:length(S))...)
  res
end

end