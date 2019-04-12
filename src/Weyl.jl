"""
Let  `V` be a  real vector space.  Finite Coxeter groups  coincide with teh
finite  subgroups of  `GL(V)` which  can be  generated y reflections. *Weyl
groups*  are  the  finite  Coxeter  groups  which  can  be defined over the
rational   numbers.  We  implement  finite   Coxter  groups  as  groups  of
permutations  of  a  root  system.  Root  systems play an important role in
mathematics as they classify semi-simple Lie algebras and algebraic groups.

Let  us give precise definitions. Let `V`  be a real vector space, `Vⱽ` its
dual  and let `(,)`  be the natural  pairing between `Vⱽ`  and `V`. A *root
system*  is a finite set  of vectors `R` which  generate `V` (the *roots*),
together  with  a  map  `r↦  rⱽ`  from  `R`  to  a subset `Rⱽ` of `Vⱽ` (the
*coroots*) such that:

-  For any `r∈  R`, we have  `(rⱽ,r)=2` so that  the formula `x↦ x-(rⱽ,x)r`
defines a reflection `s_r:V→ V` with root `r` and coroot `rⱽ`.
- The reflection `s_r` stabilizes `R`.

We  will only  consider *reduced*  root systems,  i.e., such  that the only
elements  of `R` colinear with `r∈ R` are `r` and `-r`; for Weyl groups, we
also ask that the root system be *crystallographic*, that is `(rⱽ,s)` is an
integer, for any `s∈ R,rⱽ∈ Rⱽ`.

The  subgroup `W=W(R)` of  `GL(V)` generated by  the reflections `s_r` is a
finite  Coxeter group; when `R` is crystallographic, the representation `V`
of  `W`  is  defined  over  the  rational  numbers.  All finite-dimensional
(complex)  representations of a  finite Coxeter group  can be realized over
the  same field  as `V`.  Weyl groups  can be  characterized amongst finite
Coxeter  groups by the fact that all numbers `m(s,t)` in the Coxeter matrix
are in `{2,3,4,6}`.

If  we identify  `V` with  `Vⱽ` by  choosing a  `W`-invariant bilinear form
`(.;.)`;  then we have `rⱽ=2r/(r;r)`. A root system `R` is *irreducible* if
it is not the union of two orthogonal subsets. If `R` is reducible then the
corresponding  Coxeter group  is the  direct product  of the Coxeter groups
associated with the irreducible components of `R`.

The  irreducible  crystallographic  root  systems  are  classified  by  the
following  list of  *Dynkin diagrams*,  which, in  addition to  the Coxeter
matrix,  encode also the relative length of the roots. We show the labeling
of the nodes given by the function 'Diagram' described below.

```
A_n O—O—O—…—O   B_n O⇐O—O—…—O  C_n O⇒ O—O—…—O  D_n  O 2
    1 2 3 … n       1 2 3 … n      1  2 3 … n       ￨
                                                  O—O—…—O
                                                  1 3 … n

G₂ O⇛ O  F₄ O—O⇒ O—O  E₆   O 2   E₇   O 2     E₈    O 2
   1  2     1 2  3 4       ￨          ￨             ￨
                       O—O—O—O—O  O—O—O—O—O—O   O—O—O—O—O—O—O
                       1 3 4 5 6  1 3 4 5 6 7   1 3 4 5 6 7 8
```

These diagrams encode the presentation of the Coxeter group `W` as follows:
the vertices represent the generating reflections; an edge is drawn between
`s`  and `t` if the order `m(s,t)` of `st` is greater than `2`; the edge is
single  if  `m(s,t)=3`,  double  if  `m(s,t)=4`,  triple if `m(s,t)=6`. The
arrows  indicate the relative root lengths when `W` has more than one orbit
on  `R`, as explained below; we  get the *Coxeter Diagram*, which describes
the  underlying Weyl group, if  we ignore the arrows:  we see that the root
systems `B_n` and `C_n` correspond to the same Coxeter group.

Here  are  the  diagrams  for  the  finite  Coxeter  groups which  are  not
crystallographic:

       e        5         5
I₂(e) O—O   H₃ O—O—O  H₄ O—O—O—O
      1 2      1 2 3     1 2 3 4 

Let us now describe how the root systems are encoded in these diagrams. Let
`R`  be a root system in `V`. Then we can choose a linear form on `V` which
vanishes  on no element of `R`. According to  the sign of the value of this
linear  form on a root  `r ∈ R` we  call `r` *positive* or *negative*. Then
there  exists a unique subset `Π` of  the positive roots, called the set of
*simple  roots*, such that  any positive root  is a linear combination with
non-negative  coefficients of  roots in  `Π`. Any  two sets of simple roots
(corresponding  to  different  choices  of  linear  forms  as above) can be
transformed into each other by a unique element of `W(R)`. Hence, since the
pairing  between `V` and `Vⱽ`  is `W`-invariant, if `Π`  is a set of simple
roots  and if  we define  the *Cartan  matrix* as  being the  `n` times `n`
matrix   `C={rⱽ(s)}_{rs}`,  for  `r,s∈Π`  this   matrix  is  unique  up  to
simultaneous  permutation of rows and columns.  It is precisely this matrix
which is encoded in a Dynkin diagram, as follows.

The  indices for the rows of `C` label the nodes of the diagram. The edges,
for  `r ≠ s`, are  given as follows. If  `C_{rs}` and `C_{sr}` are integers
such  that `|C_{rs}|≥|C_{sr}|=1`  the vertices  are connected by `|C_{rs}|`
lines,  and if `|C_{rs}|>1`  then we put  an additional arrow  on the lines
pointing  towards the node with label `s`.  In other cases, we simply put a
single   line  equipped  with  the  unique  integer  `p_{rs}≥1`  such  that
`C_{rs}C_{sr}=cos^2 (π/p_{sr})`.

Conversely,  the whole root  system can be  recovered from the simple roots
and  the corresponding coroots. The  reflections in `W(R)` corresponding to
the  simple roots are called  *simple* reflections or *Coxeter generators*.
They are precisely the generators for which the Coxeter diagram encodes the
defining  relations of `W(R)`. Each root is  in the orbit of a simple root,
so  that `R` is obtained  as the orbit of  the simple roots under the group
generated  by  the  simple  reflections.  The  restriction  of  the  simple
reflections  to the span of `R` is  determined by the Cartan matrix, so `R`
is determined by the Cartan matrix and the set of simple roots.

The  Cartan  matrix  corresponding  to  one  of  the above irreducible root
systems  (with the specified labeling) is  returned by the command 'cartan'
which  takes as input  a `Symbol` giving  the type (that  is ':A', ':B', …,
':I')  and a positive `Int` giving the  rank (plus an `Int` giving the bond
for  type `:I`).  This function  returns a  matrix with  entries in `ℤ` for
crystallographic  types, and a  matrix of `Cyc`  for the other types. Given
two  Cartan matrices `c1` and `c2`,  their matrix direct sum (corresponding
to  the  orthogonal  direct  sum  of  the  root systems) can be produced by
`cat(c1,c2,dims=[1,2])`.

The  function 'rootdatum' takes as input a  list of simple roots and a list
of the corresponding coroots and produces a `struct` containing information
about  the root system `R` and about `W(R)`. If we label the positive roots
by  '1:N', and the negative roots  by 'N+1:2N', then each simple reflection
is  represented by the permutation of '1:2N' which it induces on the roots.
If  only one argument is given, the Cartan matrix of the root system, it is
taken  as the list  of coroots and  the list of  roots is assumed to be the
canonical basis of `V`.

If one only wants to work with Cartan matrices with a labeling as specified
by  the  above  list,  the  function  call  can  be  simplified. Instead of
'rootdatum(CartanMat(:D,4))' the following is also possible.

```julia-repl
julia> W=coxgroup(:D,4)
W(D₄)

julia> cartan(W)
4×4 Array{Int64,2}:
  2   0  -1   0
  0   2  -1   0
 -1  -1   2  -1
  0   0  -1   2
```

Also,  the Weyl group struct associated to a direct sum of irreducible root
systems can be obtained as a product

```julia-repl
julia> W=coxgroup(:A,2)*coxgroup(:B,2)
W(A₂)× W(B₂)₍₃₄₎

julia> cartan(W)
4×4 Array{Int64,2}:
  2  -1   0   0
 -1   2   0   0
  0   0   2  -2
  0   0  -1   2
```
The  same `struct`  is constructed  by applying  'coxgroup' to  the matrix
'cat(cartan(:A,2), cartan(:B,2),dims=[1,2])'.

The elements of a Weyl group are permutations of the roots:
```julia-repl
julia> W=coxgroup(:D,4)
W(D₄)

julia> p=W(1,3,2,1,3)
{Int16}(1,14,13,2)(3,17,8,18)(4,12)(5,20,6,15)(7,10,11,9)(16,24)(19,22,23,21)

julia> word(W,p)
5-element Array{Int64,1}:
 1
 3
 1
 2
 3

```
This module is mostly a port of the basic functions on Weyl groups in CHEVIE.
The dictionary from CHEVIE is as follows:
```
     CartanMat("A",5)                       →  cartan(:A,5) 
     CoxeterGroup("A",5)                    →  coxgroup(:A,5) 
     Size(W)                                →  length(W) 
     ForEachElement(W,f)                    →  for w in W f(w) end 
     ReflectionDegrees(W)                   →  degrees(W) 
     IsLeftDescending(W,w,i)                →  isleftdescent(W,w,i) 
     ReflectionSubgroup                     →  reflection_subgroup
     TwoTree(m)                             →  twotree(m) 
     FiniteCoxeterTypeFromCartanMat(m)      →  type_cartan(m) 
     RootsCartan(m)                         →  roots(m) 
     PrintDiagram(W)                        →  Diagram(W) 
     Inversions                             →  inversions 
     Reflection                             →  reflection 
     W.orbitRepresentative[i]               →  simple_representative(W,i) 
```
finally, a benchmark on julia 1.0.2
```benchmark
julia> @btime length(elements(coxgroup(:E,7)))
  531.385 ms (5945569 allocations: 1.08 GiB)
```
GAP3 for the same computation takes 2.2s
"""
module Weyl

export coxgroup, AbstractFiniteCoxeterGroup, inversions, two_tree, rootdatum

using Gapjm, LinearAlgebra
#------------------------ Cartan matrices ----------------------------------
"""
    `cartan(type, rank)`

Cartan matrix for a Weyl group:

```julia-repl
julia> cartan(:A,4)
4×4 Array{Int64,2}:
  2  -1   0   0
 -1   2  -1   0
  0  -1   2  -1
  0   0  -1   2
```
"""
function PermRoot.cartan(t::Symbol,r::Int=0,b::Int=0)
  if t==:A return Matrix(SymTridiagonal(fill(2,r),fill(-1,r-1))) end
  m=cartan(:A,r) 
  if t==:B m[1,2]=-2 
  elseif t==:C m[2,1]=-2 
  elseif t==:D m[1:3,1:3]=[2 0 -1; 0 2 -1;-1 -1 2]
  elseif t==:E m[1:4,1:4]=[2 0 -1 0; 0 2 0 -1;-1 0 2 -1;0 -1 -1 2]
  elseif t==:F m[3,2]=-2 
  elseif t==:G m[2,1]=-3
  elseif t==:H m=Cyc{Int}.(m) 
    m[1,2]=m[2,1]=E(5,2)+E(5,3)
  elseif t==:I 
    if b%2==0 return [2 -1;-2-E(b)-E(b,-1) 2]
    else return [2 -E(2*b)-E(2*b,-1);-E(2*b)-E(2*b,-1) 2]
    end
  end
  m
end

function PermRoot.cartan(t::Dict{Symbol,Any})
  if haskey(t,:cartantype) && t[:series]==:B &&t[:cartantype]==1
       cartan(:C,length(t[:indices]))
  elseif haskey(t,:bond) cartan(:I,2,t[:bond])
  else cartan(t[:series],length(t[:indices]))
  end
end

"""
    two_tree(m)

 Given  a square  matrix m  with zeroes  (or falses,  for a boolean matrix)
 symmetric  with respect to the diagonal, let  G be the graph with vertices
 axes(m)[1] and an edge between i and j iff !iszero(m[i,j]).
 If G  is a line this function returns it as a Vector{Int}. 
 If  G  is  a  tree  with  one  vertex  c of valence 3 the function returns
 (c,b1,b2,b3)  where b1,b2,b3 are  the branches from  this vertex sorted by
 increasing length.
 Otherwise the function returns `nothing`
```julia-repl
julia> Weyl.two_tree(cartan(:A,4))
4-element Array{Int64,1}:
 1
 2
 3
 4

julia> Weyl.two_tree(cartan(:E,8))
(4, [2], [3, 1], [5, 6, 7, 8])
```
"""
two_tree=function(m::AbstractMatrix)
  function branch(x)
    while true
      x=findfirst(i->m[x,i]!=0 && !(i in line),axes(m,2))
      if !isnothing(x) push!(line,x) else break end
    end
  end
  line=[1]
  branch(1)
  l=length(line)
  branch(1)
  line=vcat(line[end:-1:l+1],line[1:l])
  l=length(line)
  if any(i->any(j->m[line[j],line[i]]!=0,1:i-2),1:l) return nothing end
  r=size(m,1)
  if l==r return line end
  p = findfirst(x->any(i->!(i in line)&&(m[x,i]!=0),1:r),line)
  branch(line[p])
  if length(line)!=r return nothing end
  (line[p],sort([line[p-1:-1:1],line[p+1:l],line[l+1:r]], by=length)...)
end

" (series,rank) for an irreducible Cartan matrix"
function type_irred_cartan(m::AbstractMatrix)
  rank=size(m,1)
  s=two_tree(m)
  if isnothing(s) return nothing end
  t=Dict{Symbol,Any}()
  if s isa Tuple # types D,E
    (vertex,b1,b2,b3)=s
    if length(b2)==1 t[:series]=:D 
      t[:indices]=[b1;b2;vertex;b3]::Vector{Int}
    else t[:series]=:E 
      t[:indices]=[b2[2];b1[1];b2[1];vertex;b3]::Vector{Int}
    end 
  else  # types A,B,C,F,G,H,I
    l=i->m[s[i],s[i+1]]
    r=i->m[s[i+1],s[i]] 
    function rev() s=s[end:-1:1] end
    if rank==1 t[:series]=:A 
    elseif rank==2 
      if l(1)*r(1)==1 t[:series]=:A 
      elseif l(1)*r(1)==2 t[:series]=:B  
        if l(1)==-1 rev() end # B2 preferred to C2
        t[:cartantype]=2
      elseif l(1)*r(1)==3 t[:series]=:G  
        if l(1)!=-1 rev() end 
        t[:cartantype]=1
      else n=conductor(l(1)*r(1))
        if r(1)==-1 || (r(1)==-1 && r(1)>l(1)) rev() end
        if l(1)*r(1)==2+E(n)+E(n,-1) bond=n else bond=2n end
        t[:series]=:I
        if bond%2==0 t[:cartantype]=-l(1) end
        t[:bond]=bond
      end
    else
      if l(rank-1)*r(rank-1)!=1 rev() end 
      if l(1)*r(1)==1
        if l(2)*r(2)==1 t[:series]=:A 
        else t[:series]=:F
          if l(2)!=-1 rev() end 
        end
        t[:cartantype]=1
      else n=conductor(l(1)*r(1))
        if n==5 t[:series]=:H
        else t[:series]=:B
          t[:cartantype]=-l(1)
        end  
      end  
    end 
    t[:indices]=s::Vector{Int}
  end 
  if cartan(t)!=m[t[:indices],t[:indices]] return nothing end  # countercheck
  t
end

"""
    type_cartan(C)

 return a list of (series=s,indices=[i1,..,in]) for a Cartan matrix
"""
function type_cartan(m::AbstractMatrix)
  map(blocks(m)) do I
    t=type_irred_cartan(m[I,I])
    t[:indices]=I[t[:indices]]
    TypeIrred(t)
  end
end

"""
    roots(C)

 return the set of positive roots defined by the Cartan matrix C
 works for any finite Coxeter group
"""
function roots(C::Matrix)
  o=one(C)
  R=[o[i,:] for i in axes(C,1)] # fast way to get rows of one(C)
  j=1
  while j<=length(R)
    a=R[j]
    c=C*a
    for i in axes(C,1)
      if j!=i 
        v=copy(a)
        v[i]-=c[i]
        if !(v in R) push!(R,v) end
      end
    end
    j+=1
  end 
  R
end 


function coxeter_from_cartan(m)
  function find(c)
    if c in 0:4 return [2,3,4,6,0][c+1] end
    x=conductor(c)
    if c==2+E(x)+E(x,-1) return x 
    elseif c==2+E(2x)+E(2x,-1) return 2x
    else error("not a Cartan matrix of a Coxeter group")
    end
  end
  res=one(m)
  for i in 2:size(m,1), j in 1:i-1
    res[i,j]=res[j,i]=find(m[i,j]*m[j,i])
  end
  res
end

#-------Finite Coxeter groups --- T=type of elements----T1=type of roots------
abstract type AbstractFiniteCoxeterGroup{T,T1} <: CoxeterGroup{T} end

CoxGroups.coxetermat(W::AbstractFiniteCoxeterGroup)=
     coxeter_from_cartan(cartan(W))

# finite Coxeter groups have functions nref and fields rootdec
inversions(W::AbstractFiniteCoxeterGroup,w)=
     [i for i in 1:nref(W) if isleftdescent(W,w,i)]

Base.length(W::AbstractFiniteCoxeterGroup,w)=count(i->isleftdescent(W,w,i),1:nref(W))

PermRoot.refltype(W::AbstractFiniteCoxeterGroup)::Vector{TypeIrred}=
   gets(W->type_cartan(cartan(W)),W,:refltype)

"""
  The reflection degrees of W
"""
function Gapjm.degrees(W::AbstractFiniteCoxeterGroup)
  l=sort(map(length,values(groupby(sum,W.rootdec[1:W.N]))),rev=true)
  reverse(1 .+conjugate_partition(l))
end

Gapjm.degree(W::AbstractFiniteCoxeterGroup)=degree(W.G)

Base.length(W::AbstractFiniteCoxeterGroup)=prod(degrees(W))

@inline PermRoot.cartan(W::AbstractFiniteCoxeterGroup)=cartan(W.G)

Base.iterate(W::AbstractFiniteCoxeterGroup,a...)=iterate(W.G.G,a...)
#--------------- FiniteCoxeterGroup -----------------------------------------
struct FiniteCoxeterGroup{T,T1} <: AbstractFiniteCoxeterGroup{Perm{T},T1}
  G::PermRootGroup{T1,T}
  rootdec::Vector{Vector{T1}}
  N::Int
  prop::Dict{Symbol,Any}
end

(W::FiniteCoxeterGroup)(x...)=element(W.G,x...)
"number of reflections of W"
@inline CoxGroups.nref(W::FiniteCoxeterGroup)=W.N
root(W::FiniteCoxeterGroup,i)=W.G.roots[i]
CoxGroups.isleftdescent(W::FiniteCoxeterGroup,w,i::Int)=i^w>W.N

"Coxeter group from type"
coxgroup(t::Symbol,r::Int=0,b::Int=0)=rootdatum(cartan(t,r,b))

" Adjoint root datum from cartan mat"
rootdatum(C)=rootdatum(one(C),C)

" root datum"
function rootdatum(rr::Matrix,cr::Matrix)
  C=cr*permutedims(rr)
  rootdec=roots(C)
  N=length(rootdec)
  r=Ref(permutedims(rr)).*rootdec
  r=vcat(r,-r)
  # the reflections defined by Cartan matrix C
  matgens=[reflection(rr[i,:],cr[i,:]) for i in axes(C,1)]
# matgens=map(reflection,eachrow(rr),eachrow(cr))
  """
    the permutations of the roots r effected by the matrices mm
  """
  s=Perm{Int16}(sortperm(r))
  gens=map(m->inv(Perm{Int16}(sortperm(Ref(permutedims(m)).*r)))*s,matgens)
  rank=size(C,1)
  G=PermRootGroup(matgens,r,map(i->cr[i,:],1:rank),PermGroup(gens),
    Dict{Symbol,Any}(:cartan=>C))
  FiniteCoxeterGroup(G,rootdec,N,Dict{Symbol,Any}())
end

function coxgroup()
  G=PermRootGroup(Matrix{Int}[],Vector{Int}[],Vector{Int}[],
   PermGroup(Perm{Int16}[]),Dict{Symbol,Any}())
  FiniteCoxeterGroup(G,Vector{Int}[],0,Dict{Symbol,Any}())
end

function Base.show(io::IO, W::FiniteCoxeterGroup)
  repl=get(io,:limit,false)
  TeX=get(io,:TeX,false)
  if isempty(refltype(W)) 
    print(io,"coxgroup()") 
    return
  end
  n=join(map(refltype(W))do t
    indices=t[:indices]
    n=sprint(show,t; context=io)
    if indices!=eachindex(indices) && (repl|| TeX)
      ind=any(i->i>10,indices) ? join(indices,",") : join(indices)
      n*="_{($ind)}"
    end
    n
  end,repl||TeX ? "\\times " : "*")
  if repl n=TeXstrip(n) end
  print(io,n)
end
  
function matX(W::FiniteCoxeterGroup,w)
  vcat(permutedims(hcat(root.(Ref(W),(1:coxrank(W)).^w)...)))
end

function cartancoeff(W::FiniteCoxeterGroup,i,j)
  v=findfirst(x->!iszero(x),root(W,i))
  r=root(W,j)-root(W,j^reflection(W,i))
  div(r[v],root(W,i)[v])
end

function Base.:*(W::FiniteCoxeterGroup...)
  rootdatum(cat(map(cartan,W)...,dims=[1,2]))
end

"for each root index of simple representative"
CoxGroups.simple_representatives(W::FiniteCoxeterGroup)=simple_representatives(W.G)
  
"for each root element conjugative representative to root"
simple_conjugating_element(W::FiniteCoxeterGroup,i)=
   simple_conjugating_element(W.G,i)

PermRoot.reflection(W::FiniteCoxeterGroup,i::Integer)=reflection(W.G,i)

#--------------- FiniteCoxeterSubGroup -----------------------------------------
struct FiniteCoxeterSubGroup{T,T1} <: AbstractFiniteCoxeterGroup{Perm{T},T1}
  G::PermRootSubGroup{T1,T}
  rootdec::Vector{Vector{T1}}
  N::Int
  parent::FiniteCoxeterGroup{T,T1}
  prop::Dict{Symbol,Any}
end

(W::FiniteCoxeterSubGroup)(x...)=element(W.G,x...)
@inline CoxGroups.nref(W::FiniteCoxeterSubGroup)=W.N

matX(W::FiniteCoxeterSubGroup,w)=matX(W.parent,w)
@inline PermRoot.inclusion(W::FiniteCoxeterSubGroup)=W.G.inclusion
@inline @inbounds PermRoot.inclusion(W::FiniteCoxeterSubGroup,i)=W.G.inclusion[i]
@inline PermRoot.restriction(W::FiniteCoxeterSubGroup)=W.G.restriction
@inline @inbounds PermRoot.restriction(W::FiniteCoxeterSubGroup,i)=W.G.restriction[i]

"""
reflection_subgroup(W,I)
The subgroup of W generated by reflections(W)[I]

A   theorem  discovered  by  Deodhar  cite{Deo89}  and  Dyer  cite{Dye90}
independently  is that a subgroup `H` of a Coxeter system `(W,S)` generated
by  reflections has  a canonical  Coxeter generating  set, formed of the `t
∈Ref(H)`  such `l(tt')>l(t)` for any `t'∈  Ref(H)` different from `t`. This
is used by 'reflection_subgroup' to determine the Coxeter system of `H`.

```julia-repl
julia> W=coxgroup(:G,2)
W(G₂)

julia> Diagram(W)
O⇛ O
1  2

julia> H=reflection_subgroup(W,[2,6])
W(G₂)₂₄

julia> Diagram(H)
O—O
1 2
```

The  notation `W(G₂)₂₃` means  that 'W.roots[2:3]' form  a system of simple
roots for `H`.

A  reflection subgroup has specific properties  the most important of which
is  'inclusion' which gives the positions of the roots of H in the roots of
W. The inverse (partial) map is 'restriction'.

```julia-repl
julia> inclusion(H)
3-element Array{Int64,1}:
 2
 4
 6

julia> restriction(H)
12-element Array{Int64,1}:
 0
 1
 0
 2
 0
 3
 0
 0
 0
 0
 0
 0

```


If H is a standard parabolic subgroup  of a Coxeter group W then the
length function  on H (with respect  to its set of  generators) is the
restriction of  the length function on  W. This need not  no longer be
true for arbitrary reflection subgroups of W:

```julia-repl
julia> word(W,H(2))
3-element Array{Int64,1}:
 1
 2
 1
```

In  this package, finite  reflection groups are  represented as permutation
groups  on a set of roots. Consequently,  a reflection subgroup `H⊆ W` is a
permutation  subgroup, thus its elements are represented as permutations of
the roots of the parent group.

```julia-repl
julia> elH=word.(Ref(H),elements(H))
6-element Array{Array{Int64,1},1}:
 []       
 [2]      
 [1]      
 [2, 1]   
 [1, 2]   
 [1, 2, 1]

julia> elW=word.(Ref(W),elements(H))
6-element Array{Array{Int64,1},1}:
 []             
 [1, 2, 1]      
 [2]            
 [1, 2, 1, 2]   
 [2, 1, 2, 1]   
 [2, 1, 2, 1, 2]

julia> map(w->H(w...),elH)==map(w->W(w...),elW)
true

```
Another  basic result about reflection subgroups  of Coxeter groups is that
each  coset of  H in  W contains  a unique  element of  minimal length, see
`reduced`.
"""
function
 PermRoot.reflection_subgroup(W::FiniteCoxeterGroup{T,T1},I::AbstractVector{Int})where {T,T1}
  G=PermGroup(reflection.(Ref(W),I))
  inclusion=sort!(vcat(orbits(G,I)...))
  N=div(length(inclusion),2)
  if all(i->i in 1:coxrank(W),I)
    C=cartan(W)[I,I]
  else
    let N=N
    I=filter(inclusion[1:N]) do i
      cnt=0
      r=reflection(W,i)
      for j in inclusion[1:N]
        if j!=i && j^r>W.N return false end
      end
      return true
    end
    end
    G=PermGroup(reflection.(Ref(W),I))
    C=T1[cartancoeff(W,i,j) for i in I, j in I]
  end
  rootdec=roots(C)
  inclusion=map(rootdec)do r
    findfirst(isequal(sum(r.*W.rootdec[I])),W.rootdec)
  end
  restriction=zeros(Int,2*W.N)
  restriction[inclusion]=1:length(inclusion)
  G=PermRootSubGroup(G,inclusion,restriction,W.G,Dict{Symbol,Any}(:cartan=>C))
  FiniteCoxeterSubGroup(G,rootdec,N,W,Dict{Symbol,Any}())
end

function Base.show(io::IO, W::FiniteCoxeterSubGroup)
  I=W.G.inclusion[1:coxrank(W)]
  n=any(i->i>=10,I) ? join(I,",") : join(I)
  print(io,sprint(show,W.parent; context=io)*TeXstrip("_{$n}"))
end
  
PermRoot.reflection_subgroup(W::FiniteCoxeterSubGroup,I::AbstractVector{Int})=
  reflection_subgroup(W.parent,inclusion(W)[I])

@inbounds CoxGroups.isleftdescent(W::FiniteCoxeterSubGroup,w,i::Int)=inclusion(W,i)^w>W.parent.N

end
