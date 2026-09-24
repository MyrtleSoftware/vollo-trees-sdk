# Sharing the Accelerator Between Processes (SR-IOV)

By default, `vollo-rt` uses the accelerator through its PCIe physical function (PF), bound to
`vfio-pci`. Only one process can open a `vfio-pci` device at a time, so only one process can use
the accelerator.

The Vollo Trees bitstreams support SR-IOV (single-root I/O virtualisation). This lets you create up
to 16 virtual functions (VFs) on the card. Each VF appears as a separate PCIe device, so a different
process can use each one. Every VF can run every model in the loaded program.

Setting this up takes three steps:

1. [Create the VFs](#creating-the-vfs) with `load-kernel-driver.sh`. This needs root, and you
   must do it again after every reboot.
2. [Load a program onto the VFs](#loading-a-program-onto-the-vfs) with `vollo-tool setup-vfs`. This
   loads your program and writes one virtual program file for each VF. It does not need root.
3. [Use a VF](#using-a-vf-from-vollo-rt) from each process with `vollo-rt`.

## Requirements

In addition to the requirements for single-process use, the host must have Linux 4.18 or later, with
SR-IOV support and the `pci-pf-stub` kernel module.

## Creating the VFs

First find the accelerator PF's full PCI address, including the domain. `lspci -D` prints it:

```sh
$ lspci -D -d 1ed9:
0000:01:00.0 Processing accelerators: Myrtle.ai Device 000a
0000:01:00.1 Processing accelerators: Myrtle.ai Device 100a
```

The PF is the `000a` device, here `0000:01:00.0`. To create 16 VFs on it:

```sh
sudo ./load-kernel-driver.sh vfio --bdf 0000:01:00.0 --num-vfs 16
```

This binds the PF to `pci-pf-stub`, creates the VFs, and binds each VF to `vfio-pci`.

`/sys/bus/pci/devices/0000:01:00.0/sriov_totalvfs` shows the most VFs the card supports, and
`sriov_numvfs` in the same directory shows how many currently exist. `vollo-tool list` shows the
card with its VFs:

```text
DEVICE  PCI ADDRESS    KIND  DRIVER
0       0000:01:00.0   PF    pci-pf-stub  16 VFs
0.0     0000:01:02.0   VF    vfio-pci
0.1     0000:01:02.1   VF    vfio-pci
...
```

Each VF is named `<card>.<vf>`, counting from 0. For example, `0.3` is VF 3 of card 0.

## Loading a program onto the VFs

Once the VFs exist, load your program and generate the virtual programs:

```sh
$VOLLO_TREES_SDK/bin/vollo-tool setup-vfs \
  --pf 0 --num-vfs 16 --program model.vollo --output virtual-programs
```

- `--pf` is the card's device index or PCI address.
- `--num-vfs` sets how many VFs to use (VFs `0` to `N-1`). It can be anything from 1
  up to the number of VFs you created. The other VFs are disabled. If you leave this option out,
  all the VFs are used.
- `--output` is the path of a directory for `setup-vfs` to create. It must not already exist.
  `setup-vfs` writes `manifest.json` and one `vf-NNN.vollo-vf` file for each enabled VF into it.
  When it finishes, it prints each VF's name, PCI address and program file.

Before running `setup-vfs` again, for example with a different program or number of VFs, stop every
process that is using a VF. Wait for their submitted jobs to complete, then close their contexts.
Keep them stopped until `setup-vfs` succeeds, then give the new `.vollo-vf` files to your
applications. You only need to rerun `load-kernel-driver.sh` if you want more VFs than you created.

## Using a VF from `vollo-rt`

Each process opens its own VF with `vollo_rt_add_device` and loads that VF's virtual program with
`vollo_rt_load_program`, in place of the usual `vollo_rt_add_accelerator` and `.vollo` program:

```c
vollo_rt_context_t ctx;
EXIT_ON_ERROR(vollo_rt_init(&ctx));
EXIT_ON_ERROR(vollo_rt_add_device(ctx, 0, "0.3"));
EXIT_ON_ERROR(vollo_rt_load_program(ctx, "virtual-programs/vf-003.vollo-vf"));
```

Here, the `0` is the accelerator's index within this context, and `"0.3"` is the VF to open.

VF `0.3` must load `vf-003.vollo-vf`. When a process loads a virtual program, the runtime checks
that the file matches the current deployment, so always use the files from the latest `setup-vfs`.
After that, you use `vollo-rt` exactly as you would with a single accelerator. See the [C
API](c-api.md).

## Returning to single-process use

You cannot use the PF in the usual way while VFs exist. To remove them, stop every process that
is using a VF, then run:

```sh
sudo ./load-kernel-driver.sh vfio --bdf 0000:01:00.0 --num-vfs 0
```

This removes the VFs and binds the PF to `vfio-pci` again.
