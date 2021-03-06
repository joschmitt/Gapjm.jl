
chevieset(Symbol("2A"), :ClassInfo, function (n,)
        local res
        res = (chevieget(:A, :ClassInfo))(n)
        res[:classtext] = (chevieget(Symbol("2A"), :WordsClassRepresentatives))(n, res[:classparams])
        delete!(res, :orders)
        return res
    end)
chevieset(Symbol("2A"), :NrConjugacyClasses, (n->begin
            NrPartitions(n + 1)
        end))
chevieset(Symbol("2A"), :ClassParameter, function (n, w)
        local i, j, x, res, mark, cyc
        x = Perm()
        for i = w
            x = x * Perm(i, i + 1)
        end
        for i = 1:div(n + 1, 2)
            x = x * Perm(i, (n + 2) - i)
        end
        res = []
        mark = 1:n + 1
        for i = 1:n + 1
            if mark[i] != 0
                cyc = CyclePermInt(x, i)
                push!(res, length(cyc))
                for j = cyc
                    mark[j] = 0
                end
            end
        end
        Sort(res)
        return reverse(res)
    end)
chevieset(Symbol("2A"), :CharParams, (n->begin
            Partitions(n + 1)
        end))
chevieset(Symbol("2A"), :CharName, function (arg...,)
        return IntListToString(arg[2])
    end)
chevieset(Symbol("2A"), :CharInfo, (n->begin
            (chevieget(:A, :CharInfo))(n)
        end))
chevieset(Symbol("2A"), :CharTable, (CHEVIE[:compat])[:CharTable2A])
chevieset(Symbol("2A"), :HeckeCharTable, (CHEVIE[:compat])[:HeckeCharTable2A])
chevieset(Symbol("2A"), :PhiFactors, (n->begin
            map((x->begin
                        (-1) ^ x
                    end), 2:n + 1)
        end))
chevieset(Symbol("2A"), :HeckeRepresentation, function (n, param, sqrtparam, i)
        local H, res, W, p
        W = CoxeterGroup("A", n)
        H = Hecke(W, -((param[1])[1]) // (param[1])[2])
        p = (Partitions(n + 1))[i]
        res = Dict{Symbol, Any}(:gens => SpechtModel(H, p))
        res[:F] = Product((res[:gens])[LongestCoxeterWord(W)]) // GetRoot((HeckeCentralMonomials(H))[i]) * (-1) ^ (chevieget(:A, :LowestPowerFakeDegree))(p)
        return res
    end)
chevieset(Symbol("2A"), :Representation, function (n, i)
        return (chevieget(Symbol("2A"), :HeckeRepresentation))(n, map((x->begin
                            [1, -1]
                        end), 1:n), 1:n * 0 + 1, i)
    end)
chevieset(Symbol("2A"), :FakeDegree, function (n, p, q)
        local res
        res = (chevieget(:A, :FakeDegree))(n, p, Indeterminate(Rationals))
        return (-1) ^ Valuation(res) * Value(res, -q)
    end)
chevieset(Symbol("2A"), :UnipotentCharacters, function (l,)
        local uc, d, k, s, i, r
        uc = (chevieget(:A, :UnipotentCharacters))(l)
        uc[:charSymbols] = map((i->begin
                        [i]
                    end), (chevieget(:A, :CharParams))(l))
        uc[:almostHarishChandra] = uc[:harishChandra]
        ((uc[:almostHarishChandra])[1])[:relativeType] = Dict{Symbol, Any}(:orbit => [Dict{Symbol, Any}(:series => "A", :indices => 1:l, :rank => l)], :twist => Product(1:div(l, 2), (i->begin
                                Perm(i, (l + 1) - i)
                            end)), :rank => l)
        uc[:harishChandra] = []
        d = 0
        while (d * (d + 1)) // 2 <= l + 1
            k = (l + 1) - (d * (d + 1)) // 2
            if mod(k, 2) == 0
                r = k // 2
                s = Dict{Symbol, Any}(:levi => r + 1:l - r, :relativeType => Dict{Symbol, Any}(:series => "B", :indices => r:(r - 1) - r:1, :rank => r), :eigenvalue => (-1) ^ (Product(d + (-1:2)) // 8))
                if d == 0
                    (s[:relativeType])[:cartanType] = 1
                end
                if r != 0
                    s[:parameterExponents] = Concatenation([2d + 1], 0 * (2:r) + 2)
                else
                    s[:parameterExponents] = []
                end
                if k < l
                    if l - k < 10
                        s[:cuspidalName] = SPrint("{}^2A_", l - k, "")
                    else
                        s[:cuspidalName] = SPrint("{}^2A_{", l - k, "}")
                    end
                else
                    s[:cuspidalName] = ""
                end
                s[:charNumbers] = map((a->begin
                                Position(uc[:charSymbols], [PartitionTwoCoreQuotient(d, a)])
                            end), (chevieget(:B, :CharParams))(r))
                FixRelativeType(s)
                push!(uc[:harishChandra], s)
            end
            d = d + 1
        end
        for i = 1:length(uc[:families])
            if 0 != mod((uc[:a])[i] + (uc[:A])[i], 2)
                (uc[:families])[i] = Family("C'1", ((uc[:families])[i])[:charNumbers])
            end
        end
        return uc
    end)
chevieset(Symbol("2A"), :UnipotentClasses, function (r, p)
        local uc, c, t, WF, m, p
        uc = Copy((chevieget(:A, :UnipotentClasses))(r, p))
        for c = uc[:classes]
            t = Parent(c[:red])
            if length(t[:type_]) > 1
                error()
            end
            if length(t[:type_]) == 0 || Rank(t) == 1
                WF = CoxeterCoset(Parent(c[:red]))
            else
                WF = CoxeterCoset(Parent(c[:red]), Product(1:div(t[:rank], 2), (i->begin
                                    Perm(i, (t[:rank] + 1) - i)
                                end)))
            end
            t = Twistings(WF, ((c[:red])[:rootInclusion])[(c[:red])[:generatingReflections]])
            m = map((x->begin
                            ReflectionEigenvalues(x, PositionClass(x, x[:phi]))
                        end), t)
            m = map((x->begin
                            count((y->begin
                                        y == 1 // 2
                                    end), x)
                        end), m)
            p = Position(m, maximum(m))
            c[:F] = (t[p])[:phi]
        end
        return uc
    end)