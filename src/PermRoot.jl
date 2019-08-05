"""
Let  `V` be a vector space over a subfield `K` of the complex numbers; here
it  usually means  the `Rationals`,  the `Cycs`,  or a subfield. A *complex
reflection*  is an element `s∈ GL(V)` of finite order whose fixed point set
is  an hyperplane (we will in the  following just call it a *reflection* to
abbreviate;  in some literature  the term reflection  is only employed when
the  order is 2 and the more general case is called a *pseudo-reflection*).
Thus  a reflection has  a unique eigenvalue  not equal to  `1`. If `K` is a
subfield of the real numbers, this eigenvalue is necessarily equal to `-1`.

A  reflection group `W` is a group  generated by a finite number of complex
reflections.

Since  when `W` contains  a reflection `s`  it contains its  powers, `W` is
always  generated  by  reflections  `s`  with non-trivial eigenvalue `E(d)`
where  `d` is the order of `s`; we may in addition assume that `s` is not a
power  of another reflection with larger order. Such a reflection is called
*distinguished*;  it is  a canonical  generator of  the cyclic  subgroup it
generates.  The  generators  of  reflection  groups we construct are always
distinguished  reflections. In a real  reflection group all reflections are
distinguished.

Reflection groups for us are groups `W` with the following methods defined

`.nbGeneratingReflections`: the number of reflections which generate `W`

`.reflections`: a list of distinguished reflections, given as elements of
  `W`, such that a list of reflections which generate `W` is
  `W.reflections{[1..W.nbGeneratingReflections]}`.

`.OrdersGeneratingReflections`: a list (of length at least
  `W.nbGeneratingReflections`) such that its `i`-th element is the order of
  `W.reflections[i]`.  By the above conventions `W.reflections[i]` thus has
  `E(W.OrdersGeneratingReflections[i])` as its nontrivial eigenvalue.

Note  that `W`  does *not*  need to  be a  matrix group. The meaning of the
above  fields is just that `W` has a representation (called the *reflection
representation*  of  `W`)  where  the  elements  `W.reflections` operate as
reflections.  It is much more efficient  to compute with permutation groups
which  have such  fields defined,  than with  matrix groups, when possible.
Information  sufficient to determine a particular reflection representation
is stored for such groups (see `CartanMat`).

Also  note that, although `.reflections` is usually just initialized to the
generating reflections, it is usually augmented by adding other reflections
to it as computations require. For instance, when `W` is finite, the set of
all  reflections  in  `W`  is  finite  (they  are  just the elements of the
conjugacy  classes of the generating reflections and their powers), and all
the  distinguished  reflections  in  `W`  are  added to `.reflections` when
required,  for instance  when calling  `reflections(W)` which returns the
list  of all (distinguished) reflections. Note that when `W` is finite, the
distinguished reflections are in bijection with the reflecting hyperplanes.

Let  `W`  be  a  finite  reflection  group  on  the vector space `V` over a
subfield  `k` of the  complex numbers. An  efficient representation that we
use  for  computing  with  such  group  is, is a permutation
representation  on  a  `W`-invariant  set  of  root  and coroot vectors for
reflections  of `W`;  that is,  a set  `R` of  pairs `(r,r^∨)∈ V×V^*`
invariant by  `W` and  such each  distinguished reflection in `W` is
defined  by some pair in `R` (see "Reflection"). There may be several pairs
for  each reflection,  differing by  roots of  unity. This  generalizes the
usual  construction  for  Coxeter  groups  (the  case `k=ℝ `) where to each
reflection  of `W` is associated two roots,  a positive and a negative one.
For irreducible complex reflection groups, there are at least as many roots
on a given line as the order of the center of `W`.

The  finite  irreducible  complex  reflection  groups  have been completely
classified   by  Shepard  and  Todd.   They  contain  one  infinite  family
`G(de,e,r)` depending on 3 parameters, and 34 exceptional groups which have
been  given by Shephard and Todd names which range from `G₄` to `G₃₇`. They
cover the exceptional Coxeter groups, e.g., `coxgroup(:E,8)` is the same as
`G₃₇`.

We provide functions to build any finite reflection group, either by giving
a  list of  roots and  corrots defining  the generating  reflections, or in
terms  of the classification. The  output is a permutation  group on set of
roots  (see `ComplexReflectionGroup`  and `PermRootGroup`).  In the context
e.g.  of  Weyl  groups,  one  wants  to describe the particular root system
chosen  in term of the  traditional classification of crystallographic root
systems. This is done via calls to the function `coxgroup` (see the chapter
on  finite Coxeter  groups). There  is not  yet a  general theory on how to
construct  a nice set of  roots for a non-real  reflection group; the roots
chosen  here  where  obtained  case-by-case;  however, they satisfy several
important properties:

- The generating reflections satisfy braid relations which present the
  braid group associated to `W` (see "Diagram").
- The  *field of definition* of `W` is  the field `k` generated by the traces
  of  the elements  of `W`  acting on  `V`. 

It  is a theorem that  `W` may be realized  as a reflection group over `k`.
For  almost  all  irreducible  complex  reflection  groups,  the generating
matrices  for `W`  we give  have coefficients  in `k`.  Further, the set of
matrices  for all  elements of  `W` is  globally invariant under the Galois
group  of `k/ℚ `, thus the Galois  action induces automorphisms of `W`. The
exceptions are `G₂₂, G₂₇` where the matrices are in a degree two extension
of   `k`  (this  is  needed  to   have  a  globally  invariant  model,  see
[MarinMichel10]) and some dihedral groups as well as `H_3` and `H_4`, where
the  matrices given (the usual  Coxeter reflection representation over `k`)
are not globally invariant.

It turns out that all representations of a complex reflection group `W` are
defined  over the  field of  definition of  `W` (cf.  [Ben76] and D.~Bessis
thesis).  This has been known for a long  time in the case `k=ℚ `, the case
of Weyl groups: their representations are defined over the rationals.
- The Cartan matrix (see "CartanMat")  for the generating roots (those
  which  correspond to the generating reflections)  has entries in the ring
  `ℤₖ`  of  integers  of  `k`,  and  the  roots  (resp. coroots) are linear
  combination with coefficients in `ℤₖ` of a linearly independent subset of
  them.

The  finite reflection  groups are  reflection groups  as described  in the
chapter  "Reflections, and reflection groups", so in addition to the fields
for  permutation  groups  they  have the fields `.nbGeneratingReflections`,
`.OrdersGeneratingReflections`  and  `.reflections`.  They  also  have  the
following additional fields:

`roots`:  a  set  of  complex  roots  in  `V`,  given  as a list of lists
       (vectors), on which `W` has a faithful permutation representation.

`coroots`: the  coroots for the  first `.nbGeneratingReflections` roots.

In  this  chapter  we  describe  functions  available for finite reflection
groups  `W`  represented  as  permutation  groups  on a set of roots. These
functions  make use of the classification of  `W` whenever it is known, but
work even if it is not known.

Let `SV` be the symmetric algebra of `V`. The invariants of `W` in `SV` are
called  the  *polynomial  invariants*  of  `W`.  They  are  generated  as a
polynomial   ring   by   `dim   V`  homogeneous  algebraically  independent
polynomials  `f₁,…,f_{dim  V}`.  The  polynomials  `fᵢ`  are not uniquely
determined  but  their  degrees  are.  The  `fᵢ`  are  called  the  *basic
invariants*  of `W`, and their degrees the *reflection degrees* of `W`. Let
`I` be the ideal generated by the homogeneous invariants of positive degree
in  `SV`. Then `SV/I` is isomorphic to the regular representation of `W` as
a  `W`-module. It  is thus  a graded  (by the  degree of  elements of `SV`)
version  of the regular  representation of `W`.  The polynomial which gives
the  graded multiplicity  of a  character `φ`  of `W`  in the graded module
`SV/I` is called the *fake degree* of `φ`.

Dictionary from CHEVIE
```
     ReflectionSubgroup          → reflection_subgroup
     .orbitRepresentative        → simple_representatives
     .orbitRepresentativeElement → simple_conjugating_element
     Reflections                 → reflections
     ReflectionType              → refltype
     IndependentRoots            → independent_roots
     HyperplaneOrbits            → hyperplane_orbits
     W.matgens[i]                → matX(W,i)
     MatXPerm(W,p)               → matX(W,p)
     ReflectionEigenvalues       → refleigen
     ReflectionCharacter         → reflchar
     PositionClass               → position_class
     ReflectionLength            → reflength
```
"""
module PermRoot

export PermRootGroup, PRG, PRSG, 
 reflection_subgroup, simple_representatives, simple_conjugating_element, 
 reflections, reflection, Diagram, refltype, cartan, independent_roots, 
 inclusion, restriction, coroot, hyperplane_orbits, TypeIrred, refleigen,
 position_class, reflength, bipartite_decomposition, torus_order, rank, matX,
 roots, coroots, baseX, semisimplerank

using Gapjm

# coroot for an orthogonal reflection and integral root
function coroot(root::Vector,eigen::Int=-1)
  d=root'*root
  conj.(root)*(mod(2,d)==0 ? div(2,d) : coroot*2//d)
end

# coroot for an orthogonal reflection
function coroot(root::Vector,eigen::Cyc)
  conj.(root)*(1-eigen)//(root'* root)
end
#------------------------------------------------------------------------
struct TypeIrred
  prop::Dict{Symbol,Any}
end

Base.haskey(t::TypeIrred,k)=haskey(t.prop,k)
Base.getindex(t::TypeIrred,k)=t.prop[k]
indices(t::TypeIrred)=t[:indices]
series(t::TypeIrred)=t[:series]

function Base.show(io::IO, l::Vector{TypeIrred})
  repl=get(io,:limit,false)
  TeX=get(io,:TeX,false)
  if isempty(l) print(io,repl||TeX ? "W()" : coxgroup()) end
  n=join(map(l)do t
    sprint(show,t; context=io)
  end,repl||TeX ? "\\times " : "*")
  if repl n=TeXstrip(n) end
  print(io,n)
end
 
function Base.show(io::IO, t::TypeIrred)
  repl=get(io,:limit,false)
  TeX=get(io,:TeX,false)
  if haskey(t,:series)
    s=series(t)
    if s==:ST 
      if haskey(t,:ST) 
        n=repl||TeX ? "G_{$(t[:ST])}" : "ComplexReflectionGroup($(t[:ST]))"
      else 
        n=repl||TeX ? "G_{$(t[:p]),$(t[:q]),$(t[:rank])}" : 
          "ComplexReflectionGroup($(t[:p]),$(t[:q]),$(t[:rank]))"
      end
    else 
      r=length(indices(t))
      if s==:B && haskey(t,:cartantype) && t[:cartantype]==1 
        s=:C
      end
      if haskey(t,:bond)
        b=t[:bond]
        n=repl||TeX ? "$(s)_{$r}($b)" : "coxgroup(:$s,$r,$b)"
      else
        n=repl||TeX ? "$(s)_{$r}" : "coxgroup(:$s,$r)"
      end
    end
    if repl n=TeXstrip(n) end
    print(io,n)
  else
    o=order(t[:twist])
    if o!=1 
      n=repl||TeX ? "{}^{$o}" : "$o" 
      if repl n=TeXstrip(n) end
      print(io,n) 
    end
    o=length(t[:orbit])
    if o!=1 print(io,"(") end
    for t1 in t[:orbit] print(io,t1) end
    if o!=1 print(io,")") end
  end
end

struct Diagram
  types::Vector{TypeIrred}
end

function Base.show(io::IO,d::Diagram)
  for t in d.types
    series=t[:series]::Symbol
    indices=t[:indices]::Vector{Int}
    ind=repr.(indices)
    l=length.(ind)
    bar(n)="\u2014"^n
    rdarrow(n)="\u21D0"^(n-1)*" "
    ldarrow(n)="\u21D2"^(n-1)*" "
    tarrow(n)="\u21DB"^(n-1)*" "
    vbar="\UFFE8" # "\u2503"
    node="O"
    if series==:A
      println(io,join(map(l->node*bar(l),l[1:end-1])),node)
      print(io,join(ind," "))
    elseif series==:B
      println(io,node,rdarrow(max(l[1],2)),join(map(l->node*bar(l),l[2:end-1])),
        node)
      print(io,ind[1]," "^max(3-l[1],1),join(ind[2:end]," "))
    elseif series==:C
      println(io,node,ldarrow(max(l[1],2)),join(map(l->node*bar(l),l[2:end-1])),
        node)
      print(io,ind[1]," "^max(3-l[1],1),join(ind[2:end]," "))
    elseif series==:D
      println(io," "^l[1]," O $(ind[2])\n"," "^l[1]," ",vbar)
      println(io,node,bar(l[1]),map(l->node*bar(l),l[3:end-1])...,node)
      print(io,ind[1]," ",join(ind[3:end]," "))
    elseif series==:E
      dec=2+l[1]+l[3]
      println(io," "^dec,"O $(ind[2])\n"," "^dec,vbar)
      println(io,node,bar(l[1]),node,bar(l[3]),
                join(map(l->node*bar(l),l[4:end-1])),node)
      print(io,join(ind[[1;3:end]]," "))
    elseif series==:F
      println(io,node,bar(l[1]),node,ldarrow(max(l[2],2)),node,bar(l[3]),node)
      print(io,ind[1]," ",ind[2]," "^max(3-l[2],1),ind[3]," ",ind[4])
    elseif series==:G
      println(io,node,tarrow(max(l[1],2)),node)
      print(io,ind[1]," "^max(3-l[1],1),ind[2])
    end
  end
end

#---------------------------------------------------------------------------
abstract type PermRootGroup{T,T1<:Integer}<:Group{Perm{T1}} end 

Diagram(W::PermRootGroup)=Diagram(refltype(W))
Gapjm.gens(W::PermRootGroup)=gens(W.G)
Gapjm.degree(W::PermRootGroup)=degree(W.G)
Base.length(W::PermRootGroup)=length(W.G)
Base.iterate(W::PermRootGroup,x...)=iterate(W.G,x...)
Base.eltype(W::PermRootGroup)=eltype(W.G)

"for each root index of simple representative"
function simple_representatives(W::PermRootGroup{T,T1})::Vector{T1} where {T,T1}
  getp(root_representatives,W,:rootreps)
end
  
"for each root element conjugative representative to root"
function simple_conjugating_element(W::PermRootGroup{T,T1},i)::Perm{T1} where{T,T1}
  getp(simple_conjugating_element,W.G,:repelms)[i]
end

function reflections(W::PermRootGroup{T,T1})::Vector{Perm{T1}} where{T,T1}
  getp(root_representatives,W,:reflections)
end

reflection(W::PermRootGroup,i)=reflections(W)[i]

function reflength(W::PermRootGroup,w::Perm)
  l=getp(refleigen,W,:reflengths)::Vector{Int}
  l[position_class(W,w)]
end

function cartan(W::PermRootGroup{T,T1})::Matrix{T} where {T,T1}
  gets(W,:cartan)do W
  [cartan_coeff(W,i,j) for i in eachindex(gens(W)), j in eachindex(gens(W))]
  end
end

function rank(W::PermRootGroup)
  if isempty(roots(W)) W.prop[:rank]
  else length(roots(W)[1])
  end
end

"""
Let W be an irreducible CRG of rank r, generated by known distinguished
reflections. type_irred classifies W (returns a type record) using:
 r=rank
 s=Size(W)/Factorial(r)
 o=the maximum order of a reflection
 h=the Coxeter number=Sum(Degrees(W)+CoDegrees(W))/r=Sum_{s∈ D} o(s)
    where D is the set of distinguished reflections of W.

G(de,e,r) has s=(de)^r/e, o=max(2,d), h=ed(r-1)+d-δ_{d,1}

(r,s,o)  are  sufficient  to  determine  a G(de,e,r) excepted for ambiguity
G(2e,e,2)/G(4e,4e,2),  which is resolved  by h (excepted  for e=1, when the
two solutions are isomorphic.

The ambiguities on (r,s,o) involving primitive groups are:  
 G9/G(24,6,2)
 G12/G(12,6,2)/G(24,24,2)
 G13/G(24,12,2)/G(48,48,2)
 G22/G(60,30,2)/G(120,120,2)
 G7/G14/G(24,8,2)
 G8/G(12,3,2) 
 G15/G(48,16,2)
 G17/G(120,24,2)
 G21/G(120,40,2)
They are resolved by h.
"""
function type_irred(W::PermRootGroup)
prim = [
  (ST=4, r=2, s=12, o=3, h=6), 
  (ST=5, r=2, s=36, o=3, h=12), 
  (ST=6, r=2, s=24, o=3, h=12), 
  (ST=7, r=2, s=72, o=3, h=18), 
  (ST=8, r=2, s=48, o=4, h=12), 
  (ST=9, r=2, s=96, o=4, h=24), 
  (ST=10, r=2, s=144, o=4, h=24), 
  (ST=11, r=2, s=288, o=4, h=36), 
  (ST=12, r=2, s=24, o=2, h=12), 
  (ST=13, r=2, s=48, o=2, h=18), 
  (ST=14, r=2, s=72, o=3, h=24), 
  (ST=15, r=2, s=144, o=3, h=30), 
  (ST=16, r=2, s=300, o=5, h=30), 
  (ST=17, r=2, s=600, o=5, h=60), 
  (ST=18, r=2, s=900, o=5, h=60), 
  (ST=19, r=2, s=1800, o=5, h=90), 
  (ST=20, r=2, s=180, o=3, h=30), 
  (ST=21, r=2, s=360, o=3, h=60), 
  (ST=22, r=2, s=120, o=2, h=30), 
  (series="H", r=3, s=20, o=2, h=10), 
  (ST=24, r=3, s=56, o=2, h=14), 
  (ST=25, r=3, s=108, o=3, h=12), 
  (ST=26, r=3, s=216, o=3, h=18), 
  (ST=27, r=3, s=360, o=2, h=30), 
  (series="F", r=4, s=48, o=2, h=12), 
  (ST=29, r=4, s=320, o=2, h=20), 
  (series="H", r=4, s=600, o=2, h=30), 
  (ST=31, r=4, s=1920, o=2, h=30), 
  (ST=32, r=4, s=6480, o=3, h=30), 
  (ST=33, r=5, s=432, o=2, h=18), 
  (ST=34, r=6, s=54432, o=2, h=42), 
  (series="E", r=6, s=72, o=2, h=12), 
  (series="E", r=7, s=576, o=2, h=18), 
  (series="E", r=8, s=17280, o=2, h=30)]

  r=length(independent_roots(W)) # semisimple rank of W
  s=div(length(W),factorial(r))
  if s==r+1 return Dict(:series => :A, :rank => r)
  elseif r==1 return Dict(:series=>:ST,:p=>s,:q=>1,:rank=>1)
  else l=([p.^(a+m-a*r,a*r-m) for a in div(m+r-1,r):div(m,r-1)]
                       for (p,m) in factor(s))
    de=vec((x->(d=prod(first.(x)),e=prod(last.(x)))).(Iterators.product(l...)))
  end
  o = maximum(order.(gens(W)))
# println("de=$de, o=$o, h=$h")
  de = filter(x->o==max(2,x.d),de)
  ST = filter(f->r==f.r && s==f.s && o==f.o,prim)
  h=div(sum(order,Set(reflections(W))),r) # Coxeter number
  if length(de)>1
    if length(de)!=2 error("theory") end
    de=sort(de)
    if h==de[1].e de=[de[1]]
    elseif h==2*de[2].e+2 de = [de[2]]
    elseif length(ST) != 1 || h != ST[1].h error("theory")
    else return Dict(:series=>:ST, :ST=>ST[1].ST, :rank=> r)
    end
  end
  if length(de) > 0 && length(ST) > 0
    ST = filter(i->i.h==h,ST)
    if length(ST) > 1 error("theory")
    elseif length(ST) > 0
      if h == de[1].d*((r-1)*de[1].e+1) error("theory") end
      return Dict(:series => :ST, :ST =>ST[1].ST, :rank=>r)
    end
  end
  if length(de) == 0
    if length(ST) != 1 error("theory")
    elseif haskey(ST[1], :ST)
         return Dict(:series=>:ST, :ST =>ST[1].ST, :rank => r)
    else return Dict(:series=>ST[1].series, :rank => r)
    end
  end
  de = de[1]
  if de.d == 2 && de.e == 1 return Dict(:series=>:B, :rank=>r) end
  if de.d == 1
      if de.e == 2 return Dict(:series=>:D,:rank=>r)
      elseif r == 2
        if de.e == 4 return Dict(:series=>:B, :rank=>2)
        elseif de.e == 6 return Dict(:series=>:G, :rank=>2)
        else return Dict(:series=>:I, :rank=>2, :bond=>de[:e])
        end
      end
  end
  return Dict(:series=>:ST, :p=>de.d * de.e, :q=>de.e, :rank=>r)
end

function refltype(W::PermRootGroup)::Vector{TypeIrred}
  gets(W,:refltype)do W
    map(blocks(cartan(W))) do I
      d=type_irred(reflection_subgroup(W,I))
      d[:indices]=I
      TypeIrred(d)
    end
  end
end

function hyperplane_orbits(W::PermRootGroup)
  orb=collect(Set(simple_representatives(W)))
  class=map(orb)do s
   findfirst(x->length(x)==1 && simple_representatives(W)[x[1]]==s,
             classinfo(W)[:classtext])
  end
  chars=chartable(W).irr
  map(zip(orb,class)) do (s,c)
    ord=order(W(s))
 #  classno=map(j->position_class(W,W(s)^j),1:ord-1)
    Ns=classinfo(W)[:classes][c]
    dets=map(1:ord-1) do j
      findfirst(i->chars[i,1]==1 && chars[i,c]==E(ord,j),axes(chars,1))
    end
    (s=s,cl_s=[c],order=ord,N_s=Ns,det_s=dets)
  end
end
  
"bipartite decomposition of eachindex(gens(W))"
function bipartite_decomposition(W)
  L=Int[]
  R=Int[]
  rest=collect(eachindex(gens(W)))
  function comm(x,y)
    p=gens(W)[x]
    q=gens(W)[y]
    return p*q==q*p
  end
  while length(rest)>0
    r=findfirst(x->any(y->!comm(x,y),L),rest)
    if r!=nothing 
      if any(y->!comm(rest[r],y),R) 
        error(W," has no bipartite decomposition")
      end
      push!(R,rest[r])
      deleteat!(rest,r)
    else r=findfirst(x->any(y->!comm(x,y),R),rest)
      if r!=nothing push!(L,rest[r]); deleteat!(rest,r)
      else push!(L,rest[1]); deleteat!(rest,1);
      end
    end
  end
  return L,R
end

tr(m)=sum(i->m[i,i],axes(m,1))
reflchar(W::PermRootGroup,w)=tr(matX(W,w))
reflchar(W::PermRootGroup)=map(x->reflchar(W,W(x...)),classinfo(W)[:classtext])
  
function refleigen(W::PermRootGroup)::Vector{Vector{Rational{Int}}}
  gets(W,:refleigen) do W
    t=chartable(W).irr[charinfo(W)[:extRefl],:]
    v=map(i->Pol([-1],1)^i,size(t,1)-1:-1:0)
    l=CycPol.((permutedims(v)*t)[1,:])
    ll=map(c->vcat(map(p->fill(p[1].r,p[2]),c.v)...),l)
    W.prop[:reflengths]=map(x->count(y->!iszero(y),x),ll)
    ll
  end
end

torus_order(W::PermRootGroup,q,i)=prod(l->q-E(l),refleigen(W)[i])

function classinv(W::PermRootGroup)
  gets(W,:classinv)do W
    map(x->cycletype(W(x...),domain=simple_representatives(W)),
         classinfo(W)[:classtext])
  end
end

function position_class(W::PermRootGroup,w)
  i=cycletype(w,domain=simple_representatives(W))
  l=findall(isequal(i),classinv(W))
  if length(l)>1 error("ambiguity") end
  l
end

function Base.show(io::IO, W::PermRootGroup)
  repl=get(io,:limit,false)
  TeX=get(io,:TeX,false)
  if isempty(refltype(W)) print(io,repl||TeX ? "W()" : coxgroup()) end
  n=join(map(refltype(W))do t
    n=sprint(show,t; context=io)
    inds=indices(t)
    if inds!=eachindex(inds)
      ind=any(i->i>10,inds) ? join(inds,",") : join(inds)
      n*="_{($ind)}"
    end
    n
  end,repl||TeX ? "\\times " : "*")
  if repl n=TeXstrip(n) end
  print(io,n)
end

function independent_roots(W::PermRootGroup)::Vector{Int}
  gets(W,:indeproots) do W
    r=roots(W)
    if isempty(r) Int[]
    else echelon(permutedims(hcat(roots(W)...)))[2]
    end
  end
end

semisimplerank(W::PermRootGroup)=length(independent_roots(W))

function baseX(W::PermRootGroup{T})::Matrix{T} where T
  gets(W,:baseX) do W
    ir=independent_roots(W)
    if isempty(ir) return one(zeros(T,rank(W),rank(W))) end
    res=permutedims(hcat(roots(W)[ir]...))
    u=permutedims(Util.nullspace(permutedims(hcat(coroot.(Ref(W),ir)...))))
    if eltype(u) <:Rational
      for v in eachrow(u) v.*=lcm(denominator.(v)...) end
      u=Int.(u)
    end
    vcat(res,u)
  end
end

function root_representatives(W::PermRootGroup)
  reps=fill(0,length(roots(W)))
  repelts=fill(one(W),length(roots(W)))
  for i in eachindex(gens(W))
    if iszero(reps[i])
      d=orbit_and_representative(W,inclusion(W,i))
      for (n,e) in d 
        reps[restriction(W,n)]=i
        repelts[restriction(W,n)]=e
      end
    end
  end
  W.prop[:rootreps]=reps
  W.prop[:repelms]=repelts
  W.prop[:reflections]=map((i,p)->gens(W)[i]^p,reps,repelts)
end

#--------------- PRG: an implementation of PermRootGroups--------------------
struct PRG{T,T1}<:PermRootGroup{T,T1}
  matgens::Vector{Matrix{T}}
  roots::Vector{Vector{T}}
  coroots::Vector{Vector{T}}
  G::PermGroup{T1}
  prop::Dict{Symbol,Any}
end

(W::PRG)(x...)=element(W.G,x...)
function PRG(r::Vector{Vector{T}},cr::Vector{Vector{T1}}) where{T,T1}
  matgens=map(reflection,r,cr)

  # the following section is quite subtle: it has the (essential -- this is
  # what  allows  to  construct  reflexion  subgroups  in a consistent way)
  # property  that the order of the  constructed roots (thus the generating
  # permutations) depends only on the Cartan matrix of g, not on the actual
  # root values.

# println("# roots: ")
  roots=map(x->convert.(eltype(matgens[1]),x),r)
  cr=map(x->convert.(eltype(matgens[1]),x),cr)
  refls=map(x->Int[],roots)
  newroots=true
  while newroots
    newroots=false
    for j in eachindex(matgens)
      lr=length(roots)
      for y in Ref(permutedims(matgens[j])).*roots[length(refls[j])+1:end]
        p=findfirst(isequal(y),roots[1:lr]) 
	if isnothing(p)
          push!(roots,y)
#         println("j=$j roots[$(length(refls[j])+1)...] ",length(roots),":",y)
          newroots=true
          push!(refls[j],length(roots))
        else push!(refls[j],p)
	end
      end
    end
#   println(" ",length(roots))
  end
# roots=map(x->convert.(eltype(matgens[1]),x),roots)
  PRG(matgens,roots,cr,Group(map(Perm{Int16},refls)),
    Dict{Symbol,Any}())
end

@inline roots(W::PRG)=W.roots
@inline coroots(W::PRG)=W.coroots
@inline coroot(W::PRG,i)=W.coroots[i]
@inline inclusion(W::PRG)=eachindex(W.roots)
@inline inclusion(W::PRG,i)=i
@inline restriction(W::PRG)=eachindex(W.roots)
@inline restriction(W::PRG,i)=i
@inline Base.parent(W::PRG)=W

"""
`reflection(root, coroot)` the matrix of the reflection of given root and coroot

A  (complex) reflection `s` acting on the vector space `V` (over a subfield
of the complex numbers), is a linear map of finite order whose fixed points
are  a hyperplane `H` (the *reflecting  hyperplane* of `s`); an eigenvector
`r` for the non-trivial eigenvalue `ζ` (a root of unity) is called a *root*
of  `s`.  If  we  choose  a  linear  form  `r^∨` (called a *coroot* of `s`)
defining  `H` such that `r^∨(r)=1-ζ` then as a linear map `s` is given by `
x↦ x-r^∨(x)r`.

A  way of specifying a  reflection is by giving  a root and a coroot, which
are  uniquely determined by the reflection up to multiplication of the root
by  a  scalar  and  of  the  coroot  by  the  inverse  scalar. The function
`reflection`  gives  the  matrix  of  the  corresponding  reflection in the
standard  basis of `V`, where the `root` and the `coroot` are vectors given
in  the  standard  bases  of  `V`  and  `V^∨`, thus `r^∨(r)` is obtained as
`permutedims(root)*coroot`.

```
julia> r=reflection([1,0,0],[2,-1,0])
3×3 Array{Int64,2}:
 -1  0  0
  1  1  0
  0  0  1

julia> r==matX(coxgroup(:A,3),1)
true

julia> r*[2,-1,0]
3-element Array{Int64,1}:
 -2
  1
  0

julia> [1 0 0]*r
1×3 Array{Int64,2}:
 -1  0  0
```
As  we see in the last lines, in our package the matrices operate an `V` as
row vectors and on `V^∨` as column vectors
"""
function reflection(root::AbstractVector,coroot::AbstractVector)
  root,coroot=promote(root,coroot)
  m=[i*j for i in coroot, j in root]
  one(m)-m
end

matX(W::PRG,i::Integer)=W.matgens[i]

" as Chevie's MatXPerm"
function matX(W::PRG,w)
  X=baseX(W)
  ir=independent_roots(W)
  if isempty(ir) return X end
  Xinv=inv(Rational.(X))
  Int.(Xinv*vcat(permutedims(hcat(W.roots[ir.^w]...)),X[length(ir)+1:end,:]))
end

function cartan_coeff(W::PRG,i,j)
  v=findfirst(x->!iszero(x),W.roots[i])
  r=W.roots[j]-W.roots[j^reflection(W,i)]
  return r[v]/W.roots[i][v];
end

#--------------- type of subgroups of PRG----------------------------------
struct PRSG{T,T1}<:PermRootGroup{T,T1}
  G::PermGroup{T1}
  inclusion::Vector{Int}
  restriction::Vector{Int}
  parent::PRG{T,T1}
  prop::Dict{Symbol,Any}
end

(W::PRSG)(x...)=element(W.G,x...)
inclusion(W::PRSG)=W.inclusion
inclusion(W::PRSG,i)=W.inclusion[i]
restriction(W::PRSG)=W.restriction
restriction(W::PRSG,i)=W.restriction[i]
@inline roots(W::PRSG)=W.parent.roots[W.inclusion]
@inline coroots(W::PRSG)=map(i->coroot(W,i),W.inclusion)
@inline coroot(W::PRSG,i)=coroot(parent(W),inclusion(W,i))
@inline Base.parent(W::PRSG)=W.parent

function reflection_subgroup(W::PRG,I::AbstractVector{Int})
  G=PRG(W.roots[I],W.coroots[I])
  if isempty(G.roots) inclusion=Int[]
  else inclusion=map(x->findfirst(isequal(x),W.roots),G.roots)
  end
  restriction=zeros(Int,length(W.roots))
  restriction[inclusion]=1:length(inclusion)
  G=Group(reflections(W)[I])
  prop=Dict{Symbol,Any}()
  if isempty(inclusion) prop[:rank]=rank(W) end
  PRSG(G,inclusion,restriction,W,prop)
end

cartan_coeff(W::PRSG,i,j)=
     cartan_coeff(parent(W),inclusion(W,i),inclusion(W,j))

matX(W::PRSG,i::Integer)=matX(parent(W),inclusion(W,i))
matX(W::PRSG,w)=matX(parent(W),w)

reflection_subgroup(W::PRSG,I::AbstractVector{Int})=
   reflection_subgroup(parent(W),inclusion(W)[I])

end
