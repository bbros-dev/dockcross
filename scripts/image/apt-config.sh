#!/usr/bin/env bash
mkdir -p /etc/apt/apt.conf.d
cat <<EOF > /etc/apt/apt.conf.d/00-resolver
Aptitude {
  Get {
    Arch-Only true;
  };
  ProblemResolver {
    SolutionCost "100*canceled-actions,200*removals";
  };
};
EOF
chmod a+x /etc/apt/apt.conf.d/00-resolver
