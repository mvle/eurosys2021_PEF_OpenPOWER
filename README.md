Instructions for enabling PEF on a standard OpenPOWER POWER9 machine, creating a SVM, and running the experiments described in our paper.
The 3 tasks are outlined below.

1. Enable PEF on standard OpenPOWER POWER9 machine.
Includes installing and configuring firmware and operating system.
These steps are captured in section 1 through section 5 in the following wiki of the ultravisor project.
[Instructions](
https://github.com/open-power/ultravisor/wiki/How-to-build-and-run-Secure-VM-using-Ultravisor-on-a-OpenPOWER-machine)

2. Create a SVM.
These steps are captured in section 6 through 10 in the above mentioned wiki.

3. Run the experiments described in the paper. Use provided (S)VM images.
[Link](https://github.com/mvle/eurosys2021_PEF_OpenPOWER/blob/master/experiments.md)

    NOTE: The steps described in Task 2 is for creating a Fedora 33 SVM image. We use Fedora 32 in our experiments. Hence, please use the provided Fedora32 SVM image for running the experiments. It also includes the necesary directory structure for the experiments and binary files for SPEC CPU2017.

We will provide 2 machines for experimentation.
One machine will not have PEF-enabled firmware (vanilla POWER9).
The second machine will have PEF-enabled firmware.

Depending on the level of familiarity with system software, Tasks 1 and 2 can be time consuming. Hence, we provide 3 options:

1. For the full experience: Task 1+2+3. Use the vanilla POWER9 machine for this purpose.
2. Tasks 2+3. Use the PEF-enabled machine.
3. Only Task 3. Use the PEF-enabled machine. Use the provided (S)VM images.
