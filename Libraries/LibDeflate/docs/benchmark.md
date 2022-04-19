# Performance Benchmark

+ Operating System: Windows 10 version 1909 (Build 18363)
+ Lua Interpreters:
  + Lua 5.1.5
  + LuaJIT 2.0.5
+ CPU: Intel Core i7-7700K@4.2 GHz

---

+ For LibDeflate, `CompressDeflate` is used for all compressions in this benchmark, `DecompressDeflate` is used for decompression. Different compression level configurations (Level 1, Level 5 and Level 8) are used.

+ For LibCompress, `Compress`, `CompressLZW`, `CompressHuffman` are used for
compression. `Decompress` is used to decompress all compression results.
`Compress` runs both CompressLZW and CompressHuffman and pick the smallest result.

---

+ Interpreter: Lua 5.1.5
+ Input data: [WeakAuras2 String](https://raw.githubusercontent.com/SafeteeWoW/LibDeflate/master/tests/data/warlockWeakAuras.txt), Size: 132462 bytes

<table>
<thead>
<tr>
<th></th>
<th>LibDeflate</th>
<th>LibDeflate</th>
<th>LibDeflate</th>
<th>LibCompress</th>
<th>LibCompress</th>
<th>LibCompress</th>
</tr>
</thead>
<tbody>
<tr>
<td></td>
<td>CompressDeflate Level 1</td>
<td>CompressDeflate Level 5</td>
<td>CompressDeflate Level 8</td>
<td>Compress</td>
<td>CompressLZW</td>
<td>CompressHuffman</td>
</tr>
<tr>
<td>compress ratio</td>
<td>3.15</td>
<td>3.68</td>
<td>3.71</td>
<td>1.36</td>
<td>1.20</td>
<td>1.36</td>
</tr>
<tr>
<td>compress time(ms)</td>
<td>68</td>
<td>116</td>
<td>189</td>
<td>111</td>
<td>52</td>
<td>50</td>
</tr>
<tr>
<td>decompress time(ms)</td>
<td>48</td>
<td>30</td>
<td>27</td>
<td>55</td>
<td>26</td>
<td>59</td>
</tr>
<tr>
<td>compress+decompress time(ms)</td>
<td>116</td>
<td>145</td>
<td>216</td>
<td>166</td>
<td>78</td>
<td>109</td>
</tr>
</tbody>
</table>

---

+ Interpreter: Lua 5.1.5
+ Input data: [Total RP3 Extended Campaign](https://raw.githubusercontent.com/SafeteeWoW/LibDeflate/master/tests/data/totalrp3.txt), Size: 191755 bytes

<table>
<thead>
<tr>
<th></th>
<th>LibDeflate</th>
<th>LibDeflate</th>
<th>LibDeflate</th>
<th>LibCompress</th>
<th>LibCompress</th>
<th>LibCompress</th>
</tr>
</thead>
<tbody>
<tr>
<td></td>
<td>CompressDeflate Level 1</td>
<td>CompressDeflate Level 5</td>
<td>CompressDeflate Level 8</td>
<td>Compress</td>
<td>CompressLZW</td>
<td>CompressHuffman</td>
</tr>
<tr>
<td>compress ratio</td>
<td>6.31</td>
<td>7.64</td>
<td>8.14</td>
<td>2.33</td>
<td>2.33</td>
<td>1.63</td>
</tr>
<tr>
<td>compress time(ms)</td>
<td>58</td>
<td>120</td>
<td>457</td>
<td>119</td>
<td>51</td>
<td>64</td>
</tr>
<tr>
<td>decompress time(ms)</td>
<td>29</td>
<td>26</td>
<td>26</td>
<td>18</td>
<td>19</td>
<td>81</td>
</tr>
<tr>
<td>compress+decompress time(ms)</td>
<td>87</td>
<td>146</td>
<td>483</td>
<td>137</td>
<td>70</td>
<td>145</td>
</tr>
</tbody>
</table>

---

+ Interpreter: LuaJIT 2.0.5
+ Input data: [WeakAuras2 String](https://raw.githubusercontent.com/SafeteeWoW/LibDeflate/master/tests/data/warlockWeakAuras.txt), Size: 132462 bytes

<table>
<thead>
<tr>
<th></th>
<th>LibDeflate</th>
<th>LibDeflate</th>
<th>LibDeflate</th>
<th>LibCompress</th>
<th>LibCompress</th>
<th>LibCompress</th>
</tr>
</thead>
<tbody>
<tr>
<td></td>
<td>CompressDeflate Level 1</td>
<td>CompressDeflate Level 5</td>
<td>CompressDeflate Level 8</td>
<td>Compress</td>
<td>CompressLZW</td>
<td>CompressHuffman</td>
</tr>
<tr>
<td>compress ratio</td>
<td>3.15</td>
<td>3.68</td>
<td>3.71</td>
<td>1.36</td>
<td>1.20</td>
<td>1.36</td>
</tr>
<tr>
<td>compress time(ms)</td>
<td>20</td>
<td>28</td>
<td>31</td>
<td>25</td>
<td>27</td>
<td>4</td>
</tr>
<tr>
<td>decompress time(ms)</td>
<td>5</td>
<td>4</td>
<td>4</td>
<td>8</td>
<td>7</td>
<td>8</td>
</tr>
<tr>
<td>compress+decompress time(ms)</td>
<td>25</td>
<td>32</td>
<td>35</td>
<td>33</td>
<td>34</td>
<td>12</td>
</tr>
</tbody>
</table>

---

+ Interpreter: LuaJIT 2.0.5
+ Input data: [Total RP3 Extended Campaign](https://raw.githubusercontent.com/SafeteeWoW/LibDeflate/master/tests/data/totalrp3.txt), Size: 191755 bytes

<table>
<thead>
<tr>
<th></th>
<th>LibDeflate</th>
<th>LibDeflate</th>
<th>LibDeflate</th>
<th>LibCompress</th>
<th>LibCompress</th>
<th>LibCompress</th>
</tr>
</thead>
<tbody>
<tr>
<td></td>
<td>CompressDeflate Level 1</td>
<td>CompressDeflate Level 5</td>
<td>CompressDeflate Level 8</td>
<td>Compress</td>
<td>CompressLZW</td>
<td>CompressHuffman</td>
</tr>
<tr>
<td>compress ratio</td>
<td>6.31</td>
<td>7.64</td>
<td>8.14</td>
<td>2.33</td>
<td>2.33</td>
<td>1.63</td>
</tr>
<tr>
<td>compress time(ms)</td>
<td>18</td>
<td>40</td>
<td>59</td>
<td>27</td>
<td>18</td>
<td>5</td>
</tr>
<tr>
<td>decompress time(ms)</td>
<td>5</td>
<td>4</td>
<td>4</td>
<td>3</td>
<td>3</td>
<td>11</td>
</tr>
<tr>
<td>compress+decompress time(ms)</td>
<td>23</td>
<td>44</td>
<td>63</td>
<td>30</td>
<td>21</td>
<td>16</td>
</tr>
</tbody>
</table>
