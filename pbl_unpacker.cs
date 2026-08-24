using System;
using System.IO;
using System.Text;
using System.Runtime.InteropServices;
using System.Collections.Generic;

namespace PblUnpacker
{
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode, Pack = 4)]
    public struct PBORCA_DIRENTRY
    {
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 256)]
        public string szComments;
        public int lCreateTime;
        public int lEntrySize;
        public IntPtr lpszEntryName;
        public int otEntryType;
    }

    [UnmanagedFunctionPointer(CallingConvention.StdCall)]
    public delegate void PBORCA_LISTPROC(IntPtr pDirEntry, IntPtr pUserData);

    class Program
    {
        [DllImport("PBORC126.DLL", CharSet = CharSet.Unicode, EntryPoint = "PBORCA_SessionOpen", CallingConvention = CallingConvention.StdCall)]
        public static extern IntPtr PBORCA_SessionOpen();

        [DllImport("PBORC126.DLL", CharSet = CharSet.Unicode, EntryPoint = "PBORCA_SessionClose", CallingConvention = CallingConvention.StdCall)]
        public static extern void PBORCA_SessionClose(IntPtr hSession);

        [DllImport("PBORC126.DLL", CharSet = CharSet.Unicode, EntryPoint = "PBORCA_SessionSetLibraryList", CallingConvention = CallingConvention.StdCall)]
        public static extern int PBORCA_SessionSetLibraryList(IntPtr hSession, string[] pLibNames, int iNumLibs);

        [DllImport("PBORC126.DLL", CharSet = CharSet.Unicode, EntryPoint = "PBORCA_LibraryDirectory", CallingConvention = CallingConvention.StdCall)]
        public static extern int PBORCA_LibraryDirectory(
            IntPtr hSession,
            string lpszLibName,
            StringBuilder lpszLibComments,
            int iCmntsBuffLen,
            PBORCA_LISTPROC pListProc,
            IntPtr pUserData);

        [DllImport("PBORC126.DLL", CharSet = CharSet.Unicode, EntryPoint = "PBORCA_LibraryEntryExport", CallingConvention = CallingConvention.StdCall)]
        public static extern int PBORCA_LibraryEntryExport(
            IntPtr hSession,
            string lpszLibName,
            string lpszEntryName,
            int otEntryType,
            StringBuilder lpszExportBuffer,
            int lExportBufferSize);

        struct EntryItem
        {
            public string Name;
            public int Type;
        }

        static List<EntryItem> currentEntries = new List<EntryItem>();

        static void DirectoryCallback(IntPtr pDirEntry, IntPtr pUserData)
        {
            if (pDirEntry == IntPtr.Zero) return;
            try
            {
                PBORCA_DIRENTRY entry = (PBORCA_DIRENTRY)Marshal.PtrToStructure(pDirEntry, typeof(PBORCA_DIRENTRY));
                if (entry.lpszEntryName != IntPtr.Zero)
                {
                    string name = Marshal.PtrToStringUni(entry.lpszEntryName);
                    if (!string.IsNullOrEmpty(name))
                    {
                        currentEntries.Add(new EntryItem { Name = name, Type = entry.otEntryType });
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Callback error: " + ex.Message);
            }
        }

        static string GetExtension(int type)
        {
            switch (type)
            {
                case 0: return ".sra";
                case 1: return ".srd";
                case 2: return ".srf";
                case 3: return ".srm";
                case 4: return ".srq";
                case 5: return ".srs";
                case 6: return ".sru";
                case 7: return ".srw";
                case 8: return ".srp";
                case 9: return ".srj";
                default: return ".srx";
            }
        }

        static void Main(string[] args)
        {
            if (args.Length < 2)
            {
                Console.WriteLine("Usage: pbl_unpacker.exe <source_dir_or_pbl> <target_recource_dir>");
                return;
            }

            string sourcePath = args[0];
            string targetDir = args[1];

            IntPtr hSession = PBORCA_SessionOpen();
            if (hSession == IntPtr.Zero)
            {
                Console.WriteLine("Failed to open PBORCA session.");
                return;
            }

            string[] pblFiles;
            if (File.Exists(sourcePath) && sourcePath.EndsWith(".pbl", StringComparison.OrdinalIgnoreCase))
            {
                pblFiles = new string[] { Path.GetFullPath(sourcePath) };
            }
            else if (Directory.Exists(sourcePath))
            {
                pblFiles = Directory.GetFiles(Path.GetFullPath(sourcePath), "*.pbl", SearchOption.TopDirectoryOnly);
            }
            else
            {
                Console.WriteLine("Invalid source path: " + sourcePath);
                PBORCA_SessionClose(hSession);
                return;
            }

            PBORCA_SessionSetLibraryList(hSession, pblFiles, pblFiles.Length);

            PBORCA_LISTPROC callback = new PBORCA_LISTPROC(DirectoryCallback);

            int totalPbls = pblFiles.Length;
            int currentPbl = 0;

            foreach (string pbl in pblFiles)
            {
                currentPbl++;
                string pblName = Path.GetFileNameWithoutExtension(pbl);
                string outPblDir = Path.Combine(targetDir, pblName);
                Directory.CreateDirectory(outPblDir);

                currentEntries.Clear();
                StringBuilder comments = new StringBuilder(256);
                int res = PBORCA_LibraryDirectory(hSession, pbl, comments, comments.Capacity, callback, IntPtr.Zero);
                if (res != 0)
                {
                    Console.WriteLine("[" + currentPbl + "/" + totalPbls + "] Error reading library: " + pbl + " (code: " + res + ")");
                    continue;
                }

                Console.WriteLine("[" + currentPbl + "/" + totalPbls + "] Processing PBL: " + pblName + " (" + currentEntries.Count + " entries)");

                StringBuilder buffer = new StringBuilder(10 * 1024 * 1024);

                foreach (var item in currentEntries)
                {
                    buffer.Clear();
                    int expRes = PBORCA_LibraryEntryExport(hSession, pbl, item.Name, item.Type, buffer, buffer.Capacity);
                    if (expRes == 0)
                    {
                        string ext = GetExtension(item.Type);
                        string outFile = Path.Combine(outPblDir, item.Name + ext);
                        File.WriteAllText(outFile, buffer.ToString(), Encoding.UTF8);
                    }
                    else
                    {
                        Console.WriteLine("   Failed to export entry: " + item.Name + " (code: " + expRes + ")");
                    }
                }
            }

            PBORCA_SessionClose(hSession);
            Console.WriteLine("Unpacking completed successfully!");
        }
    }
}
