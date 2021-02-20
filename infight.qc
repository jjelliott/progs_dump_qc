t2/*
misc_infight

target = monster that gets mad
target2 = who target1 will be angry at

spawnflag 1 = mutual hate, both targets get angry at each other instantly
*/

float INFIGHT_MUTUAL = 1;

void(entity t1, entity t2) make_angry_at =
{
    if (t2.health > 0 && t1.health > 0) { // checks if both are alive
        if (t1.enemy.classname == "player")
            t1.oldenemy = t1.enemy;
        t1.enemy = t2;

        entity oself = self;
        self = t1; // FoundTarget() only acts on self
        FoundTarget();
        self = oself;
        t1.passthru = activator;
    }
};

void() misc_infight_use =
{
    local entity    t1, t2;

    t1 = find(world, targetname, self.target);
    t2 = find(world, targetname, self.target2);

    if (!t1)
    {
        dprint("[trigger_infight] Cannot find target\n");
        return;
    }
    if (!t2)
    {
        dprint("[trigger_infight] Cannot find target2\n");
        return;
    }

    make_angry_at(t1, t2);

    if (self.spawnflags & INFIGHT_MUTUAL)
        make_angry_at(t2, t1);
};

void() misc_infight =
{
    if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
        return;

    self.use = misc_infight_use;
};
