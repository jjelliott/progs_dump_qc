/*
trigger_infight

target = monster that gets mad
target2 = who target1 will be angry at

spawnflag 1 = mutual hate, both targets get angry at each other instantly
*/

float INFIGHT_MUTUAL = 1;

void(entity t1, entity t2) make_angry_at =
{
    if (t2.health) { // checks if t2 is alive
        if (t1.enemy.classname == "player")
            t1.oldenemy = t1.enemy;
        t1.enemy = t2;

        entity oself = self;
        self = t1; // FoundTarget() only acts on self
        FoundTarget();
        self = oself;
    }
};

void() trigger_infight_use =
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

void() trigger_infight =
{
    if (SUB_Inhibit ())  // new spawnflags for all entities -- iw
        return;

    self.use = trigger_infight_use;
};
